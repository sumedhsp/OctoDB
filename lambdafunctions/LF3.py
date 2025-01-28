import json
import boto3
import hashlib
import uuid
import re

# Initialize DynamoDB and Lambda client
dynamodb = boto3.resource('dynamodb')
lambda_client = boto3.client('lambda')
table = dynamodb.Table('tenants')  # Replace with your DynamoDB table name
db_metadata = dynamodb.Table('db_metadata')

def lambda_handler(event, context):
    try:
        body = event
        # Extract user details
        name = body.get('name')
        email = body.get('email')
        password = body.get('password')
        is_admin = body.get('is_admin')
        application_name = body.get('application_name')
        sql_scripts = body.get('sql_scripts')

        temp_db_id = ""
        remarks = []
        if (not is_admin):
            temp_db_id = "admin_" + application_name
            temp_db_name = re.sub(r'[^a-zA-Z0-9]', '', temp_db_id)
            db_metadata_response = db_metadata.scan(
                        FilterExpression="db_id = :db_id AND db_name = :db_name",
                        ExpressionAttributeValues={
                            ":db_id": temp_db_id,
                            ":db_name": temp_db_name
                        }
                    )

            if (not db_metadata_response['Items']):
                remarks.append("Warning: Invalid application name. Creating an empty database!")
            else:
                remarks.append(f"Database created with the following application {application_name} as parent")
        else:
            temp_db_id = "admin_" + application_name
            temp_db_name = re.sub(r'[^a-zA-Z0-9]', '', temp_db_id)
            db_metadata_response = db_metadata.scan(
                        FilterExpression="db_id = :db_id AND db_name = :db_name",
                        ExpressionAttributeValues={
                            ":db_id": temp_db_id,
                            ":db_name": temp_db_name
                        }
                    )
            
            if (db_metadata_response['Items']):
                return {
                "statusCode": 500,
                "body": json.dumps({"message": f"Application name already exists. Please change the application name"})
                }

        # Validate required fields
        if not name or not email or not password:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Missing required fields"})
            }

        # Hash the password
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        
        tenant_id = str(uuid.uuid4())
        db_id = str(uuid.uuid4())
        if is_admin=="True":
            is_admin = True
            db_id = "admin_"+application_name
        else:
            is_admin = False
        # Insert into DynamoDB

        item = {
            "tenant_id": tenant_id,
            "email": email,
            "name": name,
            "password_hash": hashed_password,
            "db_id": db_id,
            "auth_key": None,
            "is_admin": is_admin
        }

        try:
            table.put_item(Item=item)

            # Invoke the secondary Lambda for SQLite file creation
            lambda_client.invoke(
                FunctionName='testDbCreation',
                InvocationType='Event',
                Payload=json.dumps({
                    "db_id": db_id,
                    "tenant_id": tenant_id,
                    "email": email,
                    "application_name": application_name,
                    "is_admin": is_admin,
                    "sql_scripts": sql_scripts
                })
            )

            return {
                "statusCode": 201,
                "body": json.dumps({"message": f"User created successfully", "remarks": remarks})
            }
        except Exception as e:
            return {
                "statusCode": 500,
                "body": json.dumps({"message": f"An error occurred: {str(e)}"})
            }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"An error occurred: {str(e)}"})
        }