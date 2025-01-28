import sqlite3
import boto3
import os
import json
import logging
import time
import uuid
import re
from datetime import datetime

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2_client = boto3.client('ec2')
dynamodb = boto3.resource('dynamodb')
db_table = dynamodb.Table('db_metadata')
table = dynamodb.Table('table_metadata')
sqs = boto3.client('sqs')

def mask_sensitive_info(text):
    # Mask IPs and ports
    text = re.sub(r'\b(?:\d{1,3}\.){3}\d{1,3}(?::\d+)?', 'xxx.xxx.xxx.xxx', text)
    # Mask schema IDs/hashes
    text = re.sub(r'\b[a-f0-9]{32}\b', '***', text)
    # Mask paths containing sensitive info
    text = re.sub(r'/home/[^/\s]+/schemas/[a-zA-Z0-9]+', '/home/ec2-user/schemas/***', text)
    return text

def filter_and_format_logs(log_content):
    """Filter lines starting with dates and mask sensitive information"""
    filtered_logs = []
    
    # Split content into lines
    lines = log_content.split('\n')
    
    # Date patterns (both formats from your logs)
    # date_pattern = r'^\d{4}-\d{2}-\d{2}'
    
    for line in lines:
        # Only process lines that start with a date and don't contain "Warning"
        if "Warning" not in line:
            # Mask sensitive information
            masked_line = mask_sensitive_info(line)
            filtered_logs.append(masked_line)
    
    return '\n'.join(filtered_logs)

def get_command_output(ssm_client, command_id, instance_id, tenant_id):
    try:
        sqs = boto3.client('sqs')
        QUEUE_URL='https://sqs.us-east-2.amazonaws.com/571600864139/log_queue'
        output = ssm_client.get_command_invocation(
            CommandId=command_id,
            InstanceId=instance_id
        )
        
        print(f"Command Status: {output['Status']}")
        print(f"Execution Start: {output['ExecutionStartDateTime']}")
        print(f"Execution Time: {output['ExecutionElapsedTime']}")
        
        print("\nFiltered Output:")
        # Filter and mask stderr content
        stderr = filter_and_format_logs(output['StandardErrorContent'].strip())
        print(stderr,'stderr')
        if stderr:
            message = {
            'tenant_id': tenant_id,  # Or however you get your tenant_id
            'stderr': stderr
            }
            print('message',message)
            print(stderr)
            sqs_response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(message)
            )
            print(f"Sent stderr to SQS: {stderr}")
            print(f"SQS Response for stderr: {sqs_response}")
        # Filter and mask stdout content
        stdout = filter_and_format_logs(output['StandardOutputContent'].strip())
        print('stdout',stdout)
        if stdout:
            message = {
            'tenant_id': tenant_id,  # Or however you get your tenant_id
            'stdout': stdout
            }
            print('message',message)
            print(stdout)
            sqs_response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(message)
            )
            print(f"Sent stdout to SQS: {stdout}")
            print(f"SQS Response for stdout: {sqs_response}")
        return True
    except Exception as e:
        print(f"Error getting command output: {str(e)}")
        return False

def lambda_handler(event, context):

    try:
        # Get user data from the event
        instance_id = 'i-045e576d617ec1c1e'
        db_host = '172.31.6.23'
        root_user = 'root';
        root_user_pwd = 'root@Pwd123'
        db_user = 'app_user'
        db_user_pwd = "App_user@123"
        db_id = event['db_id']
        tenant_id = event['tenant_id']
        print('tenant_id',tenant_id)
        print('event', event)
        db_name = re.sub(r'[^a-zA-Z0-9]', '', db_id)
        dir_name = db_name

        is_admin = event['is_admin']
        application_name = event['application_name']
        admin_db_id = "admin_"+application_name
        admin_db_name = re.sub(r'[^a-zA-Z0-9]', '', admin_db_id)
        admin_db_dir_name = admin_db_name
        sql_scripts = event['sql_scripts']

        if is_admin:
            create_tables_commands = ""
            table_names_default = []
            for sql_script in sql_scripts:
                for table_name, sql in sql_script.items():
                    table_names_default.append(table_name)
                    file_path = f"/home/ec2-user/schemas/{db_name}/{table_name}.sql"
                    create_tables_commands = create_tables_commands +"\n"+ f"""echo "{sql}" > "{file_path}";"""
        else:
            table_names_default = ['channels', 'directmessages', 'messages', 'users', 'userchannels']
            create_tables_commands = f"cp -r /home/ec2-user/schemas/{admin_db_name}/* /home/ec2-user/schemas/{db_name}/"

        skeema_cmds = f"""
            mysql -u {root_user} -p{root_user_pwd} -e "CREATE DATABASE IF NOT EXISTS {db_name};"
            mysql -u root -proot@Pwd123 -e "FLUSH PRIVILEGES;"
            mysql -u root -proot@Pwd123 -e "GRANT ALL PRIVILEGES ON {db_name}.* TO '{db_user}'@'%';"
            mysql -u root -proot@Pwd123 -e "FLUSH PRIVILEGES;"
            cd /home/ec2-user/schemas/
            skeema init -h {db_host} -u {db_user} --schema={db_name} --dir={db_name} --password={db_user_pwd};
            {create_tables_commands}
            cd {db_name}   
            skeema push --password={db_user_pwd};
        """

        # skeema diff --password={db_user_pwd};
        ssm_client = boto3.client('ssm', region_name='us-east-2')
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            TimeoutSeconds=30,
            Parameters={
                'commands': [
                skeema_cmds
            ]
            },
            CloudWatchOutputConfig={
                'CloudWatchLogGroupName': 'my-ssm-logs',
                'CloudWatchOutputEnabled': True
            }
        )
        print(response)
        command_id = response['Command']['CommandId']
        print(command_id)

        time.sleep(5)
        # ssm_client = boto3.client('ssm')
        get_command_output(ssm_client, command_id, instance_id, tenant_id)
        print('command',get_command_output)

        # output = ssm_client.get_command_invocation(
        #     CommandId=command_id,
        #     InstanceId=instance_id
        # )
        # print(1)

        # print(1, output['StandardErrorContent'].strip())
        # print(2, output['StandardOutputContent'].strip())

        db_table.put_item(Item={
            "db_id": db_id,
            "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "db_name": db_name,
        })

        db_response = db_table.scan(
            FilterExpression="db_id = :db_id",
            ExpressionAttributeValues={
                ":db_id": db_id,
            }
        )

        if is_admin:
            if db_response.get('Items'):
                for table_name in table_names_default:
                    table_id = str(uuid.uuid4())
                    table.put_item(Item={
                        "table_id": table_id,
                        "table_name": table_name,
                        "db_id": db_id,
                        "schema_version": '1.0',
                        "custom_schema": False,
                        "parent": None
                    })
        else:
            if db_response.get('Items'):
                admin_table_db_responses = table.scan(
                    FilterExpression="db_id = :db_id",
                    ExpressionAttributeValues={
                        ":db_id": admin_db_id,
                    }
                )
                print(admin_table_db_responses)
                for admin_table in admin_table_db_responses['Items']:
                    table_id = str(uuid.uuid4())
                    table.put_item(Item={
                        "table_id": table_id,
                        "table_name": admin_table['table_name'],
                        "db_id": db_id,
                        "schema_version": admin_table['schema_version'],
                        "custom_schema": False,
                        "parent": admin_table['table_id']
                    })
            print("db_response", db_response)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "DB created successfully"})
        }

    except Exception as e:
        logger.error(f"An error occurred: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"An error occurred: {str(e)}"})
        }
