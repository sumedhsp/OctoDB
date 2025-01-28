import json
import boto3
import uuid
import redis
from datetime import datetime
import re

lambda_client = boto3.client('lambda')
dynamodb = boto3.resource('dynamodb')
tenants = dynamodb.Table('tenants')
db_metadata = dynamodb.Table('db_metadata')
table_metadata = dynamodb.Table('table_metadata')


def is_safe_create_table(sql_command):
    """
    Validates whether the given CREATE TABLE SQL command is safe.
    """
    # Convert to uppercase for easier keyword matching
    sql_upper = sql_command.upper().strip()
    
    # Check for disallowed keywords
    disallowed_keywords = ['DROP', 'INSERT', '--']
    if any(keyword in sql_upper for keyword in disallowed_keywords):
        return False, "Disallowed keyword(s) found in SQL command. (DROP, INSERT, --) are not allowed"
    
    # Check if there's more than one semicolon
    if sql_command.count(';') != 1 or not sql_command.endswith(';'):
        return False, "Semicolon should appear only at the end of the statement."
    
    # Validate the general structure of CREATE TABLE
    create_table_pattern = r"^CREATE\s+TABLE\s+\w+\s*\([\w\s,()]+\)\s*;$"
    if not re.match(create_table_pattern, sql_command, re.IGNORECASE):
        return False, "SQL command does not match CREATE TABLE pattern. Please follow the standard pattern"
    
    # Additional checks for nested commands
    if re.search(r"SELECT|EXEC|EXECUTE", sql_upper):
        return False, "Potential nested command found."

    return True, "SQL command is safe."

def lambda_handler(event, context):

    tenant_id = event['requestContext']['authorizer']['tenant_id']
    db_id = event['requestContext']['authorizer']['db_id']
    db_name = db_id.replace('-', '')
    email = event['requestContext']['authorizer']['email']
    is_admin = event['requestContext']['authorizer']['is_admin']

    body = json.loads(event["body"])
    sql_scripts = body['sql_scripts']
    migration_timestamp = datetime.now().strftime("%Y%m%d%H%M%S")

    jobs = []
    job_ids = []
    for sql_script in sql_scripts:
        for table_name, sql in sql_script.items():
            
            # Validating the schema submitted by the user
            print(f"Performing sanity check on the sql query to avoid malicious activities")
            is_safe, remarks = is_safe_create_table(sql)
            if not is_safe:
                print (remarks)
                return {
                    'statusCode': 500,
                    'body': json.dumps('Migration cancelled. An error occurred while processing the query :' + remarks)
                }
            
            print(f"Executing script for {table_name}:")
            print(sql)
            job_id = str(uuid.uuid4())
            job = {
                'job_id': job_id,
                'tenant_id': tenant_id,
                'db_id': db_id,
                'db_name': db_name,
                'table_name': table_name,
                'sql': sql,
                'migration_timestamp': migration_timestamp,
                'is_admin': is_admin,
                'email':email
            }
            job_ids.append(job_id)
            jobs.append(job)
            
            if is_admin == "true":
                ## migrate children
                table_metadata_response = table_metadata.scan(
                    FilterExpression="db_id = :db_id AND table_name = :table_name",
                    ExpressionAttributeValues={
                        ":db_id": db_id,
                        ":table_name": table_name
                    }
                )

            
                if table_metadata_response['Items']:
                    table_id = table_metadata_response['Items'][0]['table_id']
                    children_table_metadata_response = table_metadata.scan(
                        FilterExpression="parent = :parent",
                        ExpressionAttributeValues={
                            ":parent": table_id
                        }
                    )
                    for child in children_table_metadata_response['Items']:
                        child_tenant_id = None
                        child_db_id = child['db_id']
                        child_db_name = child_db_id.replace('-', '')
                        child

                        child_tenants_metadata = tenants.scan(
                            FilterExpression="db_id = :db_id",
                            ExpressionAttributeValues={
                                ":db_id": child_db_id
                            }
                        )
                        if child_tenants_metadata['Items']:
                            child_tenant_id = child_tenants_metadata['Items'][0]['tenant_id']
                            child_tenant_email = child_tenants_metadata['Items'][0]['email']

                            job_id = str(uuid.uuid4())
                            job = {
                                'job_id': job_id,
                                'tenant_id': child_tenant_id,
                                'db_id': child_db_id,
                                'db_name': child_db_name,
                                'table_name': table_name,
                                'sql': sql,
                                'migration_timestamp': migration_timestamp,
                                'is_admin': is_admin,
                                'email': child_tenant_email
                            }
                            job_ids.append(job_id)
                            jobs.append(job)

    print(len(jobs), jobs)
    elasticache_endpoint = "3.143.213.198" 
    redis_password = "redistest"
    redis_client = redis.Redis(host=elasticache_endpoint, port=6379, password=redis_password)
    for job in jobs:
        ## add to redis here
        key = job['job_id']
        retryCount = "1"

        cache_response = redis_client.set(key, retryCount)
        if (cache_response):
            print(f"{key} job_id is successfully inserted into cache")

        ## invoke M1
        try:
            lambda_client.invoke(
                FunctionName='M1',
                InvocationType='Event',
                Payload=json.dumps(job)
            )
        except Exception as e:
            print(e)
            return {
                'statusCode': 500,
                'body': json.dumps("Could not submit job for migration. Please contact admin for support " + e)
            }
            
    return {
        'statusCode': 200,
        'body': json.dumps('Job successfully submitted for migration. Follow portal for status and updates')
    }
