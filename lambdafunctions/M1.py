import json
import boto3
import uuid
import logging
import time
import re
import os
import redis
import requests

from datetime import datetime

# Initialize logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
ec2_client = boto3.client('ec2')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('table_metadata')
migration_status_table = dynamodb.Table('migration_status')
sqs = boto3.client('sqs')
lambda_client = boto3.client('lambda')

# Define the SQS queue URL
QUEUE_URL = 'https://sqs.us-east-2.amazonaws.com/571600864139/log_queue'

def send_to_sqs(message):
    """Send a message to the SQS queue."""
    try:
        response = sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(message)
        )
        logger.info(f"Message sent to SQS: {response}")
    except Exception as e:
        logger.error(f"Failed to send message to SQS: {str(e)}")

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
        # QUEUE_URL='https://sqs.us-east-2.amazonaws.com/571600864139/log_queue'
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

def get_command_status(ssm_client, command_id, instance_id, tenant_id):
    QUEUE_URL='https://sqs.us-east-2.amazonaws.com/571600864139/log_queue'
    output = ssm_client.get_command_invocation(
        CommandId=command_id,
        InstanceId=instance_id
    )
        
    print(f"Command Status: {output['Status']}")
    return output['Status']

# To send email
def send_email(recipient_email, is_success, table_name, log_details):
    try:
        api_key = "de374b56ad2a55ef236e8cbdf87c1299-da554c25-f136c5cd"
        domain = "sandbox2129849a511340039ee9ecd1941af07a.mailgun.org"
        sender_email = "MigrationEngine@nyu.edu"
        
        heading_color = "green" if is_success else "red"
        heading_text = f"Success for {table_name}" if is_success else f"Failed for {table_name}"
        
        subject = f"Migration Status Update: {heading_text}"
        html_body = ""
        if (is_success):
            html_body = f"""
            <html>
            <body style="font-family: Arial, sans-serif;">
                <h2 style="color: {heading_color};">{heading_text}</h2>
                <p style="font-size: 16px;">Dear User,</p>
                <p style="font-size: 14px;">
                    Your request for migration of {table_name} is completed. 
                </p>
            </body>
            </html>
            """
        else:
            html_body = f"""
            <html>
            <body style="font-family: Arial, sans-serif;">
                <h2 style="color: {heading_color};">{heading_text}</h2>
                <p style="font-size: 16px;">Dear User,</p>
                <p style="font-size: 14px;">
                    Your request for migration of {table_name} is incomplete. Below are log details.
                </p>
                <pre style="background-color: #f4f4f4; padding: 10px; border-radius: 5px; font-size: 14px;">
                {log_details}
                </pre>
                <p style="font-size: 14px;"> Please look into the logs at the portal for more details. </p>
                <p style="font-size: 14px;">Best Regards,<br>Your Service Team</p>
            </body>
            </html>
            """
        
        url = f"https://api.mailgun.net/v3/{domain}/messages"
        response = requests.post(
            url,
            auth=("api", api_key),
            data={
                "from": sender_email,
                "to": recipient_email,
                "subject": subject,
                "html": html_body
            }
        )
        
        if response.status_code == 200:
            print ("Email sent successfully!")
        else:
            print (f"Failed to send email: {response.text}")
    except Exception as e:
        print(f"Error sending email: {e}")

def lambda_handler(event, context):
    instance_id = 'i-045e576d617ec1c1e'
    db_user = 'app_user'
    db_user_pwd = 'App_user@123'

    tenant_id = event['tenant_id']
    db_id = event['db_id']
    db_name = event['db_name']
    dir_name = db_name
    table_name = event['table_name']
    sql_script = event['sql']
    job_id = event['job_id']
    migration_timestamp = event['migration_timestamp']
    is_admin = event['is_admin']
    email = event['email']

    # Implement locks
    lock_file = f"/home/ec2-user/locks/{dir_name}_{table_name}.txt"

    directory_path = f"/home/ec2-user/schemas/{dir_name}/"
    file_path = f"/home/ec2-user/schemas/{dir_name}/{table_name}.sql"
    backup_dir=f"/home/ec2-user/rollback/backup_{dir_name}_{table_name}_{datetime.now().strftime("%Y%m%d%H%M%S")}/"
    backup_dir_file_path=f"{backup_dir}{table_name}.sql"

    script = f"""
    mkdir {backup_dir};
    if [ -f "{file_path}" ]; then
        mv "{file_path}" "{backup_dir}";
        echo "{sql_script}" > "{file_path}";
    else
        echo "{sql_script}" > "{file_path}";
    fi
    """
    
    roll_back_script = f"""
        rm "{file_path}";
        mv "{backup_dir_file_path}" "{directory_path}";
    """
    
    skeema_cmds = f"""
        cd {directory_path}
        skeema diff --password={db_user_pwd};
        skeema push --password={db_user_pwd} --safe-below-size=1000;
    """

    # Instantiating Redis client
    elasticache_endpoint = "3.143.213.198"
    redis_password = "redistest" 
    redis_client = redis.Redis(host=elasticache_endpoint, port=6379, password=redis_password)

    try:
        # Log start of the migration
        send_to_sqs({
            'event': 'MigrationStart',
            'tenant_id': tenant_id,
            'db_id': db_id,
            'table_name': table_name,
            'timestamp': str(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        })

        # Execute commands via SSM
        ssm_client = boto3.client('ssm', region_name='us-east-2')
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            TimeoutSeconds=30,
            Parameters={
                'commands': [
                    script,
                    skeema_cmds
                ]
            },
            CloudWatchOutputConfig={
                'CloudWatchLogGroupName': 'my-ssm-logs',
                'CloudWatchOutputEnabled': True
            }
        )
        logger.info(f"SSM Command Response: {response}")

        command_id = response['Command']['CommandId']
        time.sleep(5)
        # ssm_client = boto3.client('ssm')
        get_command_output(ssm_client, command_id, instance_id, tenant_id)
        print('migration_status', get_command_output)

        migration_status = get_command_status(ssm_client, command_id, instance_id, tenant_id)
        print('migration_status', migration_status)

        migration_status_table.put_item(Item={
                "id": str(uuid.uuid4()),
                "migration_timestamp": migration_timestamp,
                "db_id": db_id,
                "table_name": table_name,
                "migration_status": migration_status
            })
        
        if migration_status == "Failed":
            print(f"Rollback executing for {table_name}")
            response = ssm_client.send_command(
                InstanceIds=[instance_id],
                DocumentName='AWS-RunShellScript',
                TimeoutSeconds=30,
                Parameters={
                    'commands': [
                        roll_back_script,
                        skeema_cmds
                    ]
                },
                CloudWatchOutputConfig={
                    'CloudWatchLogGroupName': 'my-ssm-logs',
                    'CloudWatchOutputEnabled': True
                }
            )
            raise Exception(f"Migration failed for {table_name}; Rolling back!!")


        # Update DynamoDB table metadata
        db_response = table.scan(
            FilterExpression="db_id = :db_id AND table_name = :table_name",
            ExpressionAttributeValues={
                ":db_id": db_id,
                ":table_name": table_name
            }
        )

        if db_response['Items']:
            print(f"updating version for {table_name}")
            item = db_response['Items'][0]
            table_id = item['table_id']
            schema_version = float(item['schema_version'])
            if is_admin == "true":
                new_schema_version = str(schema_version + 1.0)
                update_response = table.update_item(
                    Key={'table_id': table_id},
                    UpdateExpression="SET schema_version = :new_version",
                    ExpressionAttributeValues={":new_version": new_schema_version},
                    ReturnValues="UPDATED_NEW"
                )
            else:
                new_schema_version = f"{schema_version:.1f}"
                new_schema_version = float(new_schema_version) + 0.1
                new_schema_version = f"{new_schema_version:.1f}"
                update_response = table.update_item(
                    Key={'table_id': table_id},
                    UpdateExpression="SET schema_version = :new_version, parent = :new_parent, custom_schema = :new_custom_schema",
                    ExpressionAttributeValues={":new_version": new_schema_version, ":new_parent": None, ":new_custom_schema": True},
                    ReturnValues="UPDATED_NEW"
                )
            logger.info(f"DynamoDB Update Response: {update_response}")
        else:
            print(f"Creating new table: {table_name}")
            table_id = str(uuid.uuid4())
            table.put_item(Item={
                "table_id": table_id,
                "table_name": table_name,
                "db_id": db_id,
                "schema_version": "0.1",
                "custom_schema": True,
                "parent": None
            })

        # Log success of the migration
        send_to_sqs({
            'event': 'MigrationSuccess',
            'tenant_id': tenant_id,
            'db_id': db_id,
            'table_name': table_name,
            'schema_version': new_schema_version if db_response['Items'] else "1.0",
            'timestamp': str(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        })

        # Notifying the user
        send_email(email, True, table_name, "")

        if (redis_client.delete(job_id)):
            print (f"{job_id} job deleted from cache")
        else:
            print (f"Couldn't delete job {job_id} from cache. Does not exist.")
        


        return {
            'statusCode': 200,
            'body': json.dumps('Migration Done!!')
        }

    except Exception as e:
        
        resp = redis_client.get(job_id)
        if (resp == None):
            # Send email through SES.    
            
            return {
                "statusCode": 500,
                "body": json.dumps({"message": f"An error occurred: {str(e)}"})
            }
        
        decoded_result = resp.decode("utf-8")
        print (f"Retrieved the cache from Redis: {job_id} : {decoded_result}")

        retryCount = int(decoded_result)

        if (retryCount >= 3):
            # Send email through SES.    
            send_email(email, False, table_name, str(e))
            
            return {
                "statusCode": 500,
                "body": json.dumps({"message": f"An error occurred: {str(e)}"})
            }
        
        new_count = str(retryCount + 1)
        cache_response = redis_client.set(job_id, new_count)
        if (cache_response):
            print(f"{job_id} job_id is successfully inserted into cache")

        print (f"Retrying the migration process again..")
        ## invoke M1
        lambda_client.invoke(
            FunctionName='M1',
            InvocationType='Event',
            Payload=json.dumps(event)
        )
        
        logger.error(f"An error occurred: {str(e)}")
        send_to_sqs({
            'event': 'MigrationFailure',
            'tenant_id': tenant_id,
            'db_id': db_id,
            'table_name': table_name,
            'error': str(e),
            'timestamp': str(uuid.uuid4())
        })
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"An error occurred: {str(e)}"})
        }
