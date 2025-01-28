import json
import boto3
import uuid
import hashlib
from datetime import datetime, timedelta
from boto3.dynamodb.conditions import Key

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tenants')

def hash_password(password):
    # Convert password to string before hashing
    password_str = str(password)
    return hashlib.sha256(password_str.encode()).hexdigest()

def lambda_handler(event, context):
    try:
        # Parse email, password, and read flag from request body
        body = event
        email = body.get('email')
        password = body.get('password')
        read = body.get('read', False)  # Default to False if not provided
        read=read=="True"
        print(f"Received email: {email}")
        print(f"Received password type: {type(password)}")
        print(f"Received email: {email}")
        print(f"Read flag: {read}")
        
        if not email or not password:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Email and password are required"})
            }
        
        # Hash the provided password
        # hashed_password = hash_password(password)
        # print(f"Hashed password: {hashed_password}")

        #changed by Anthony, sending hashed passwords directly
        
        # Query user by email
        response = table.scan(
            FilterExpression=Key('email').eq(email)
        )
        
        items = response.get('Items', [])
        if not items:
            return {
                "statusCode": 404,
                "body": json.dumps({"message": "User not found"})
            }
        
        user = items[0]
        print(f"Found user: {user}")
        
        # Verify password
        if user.get('password_hash') != password:
            return {
                "statusCode": 401,
                "body": json.dumps({"message": "Invalid credentials"})
            }
        
        tenant_id = user['tenant_id']
        
        if read:
            print("Read flag is True. Returning existing token.")
            # Return the existing token from the database
            auth_key = user.get('auth_key')
            expiration_time = user.get('auth_key_expiration')
            
            if not auth_key or not expiration_time:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"message": "No token found for user"})
                }
            
            return {
                "statusCode": 200,
                "body": json.dumps({
                    "auth_key": auth_key,
                    "expires_in": expiration_time
                })
            }
        else:
            # Generate a new auth_key
            auth_key = str(uuid.uuid4())
            expiration_time = datetime.utcnow() + timedelta(hours=48)
            
            # Update DynamoDB with the new token
            table.update_item(
                Key={"tenant_id": tenant_id},
                UpdateExpression="SET #auth_key = :auth_key, #exp = :expiration",
                ExpressionAttributeNames={
                    "#auth_key": "auth_key",
                    "#exp": "auth_key_expiration"
                },
                ExpressionAttributeValues={
                    ":auth_key": auth_key,
                    ":expiration": expiration_time.isoformat()
                }
            )
            
            return {
                "statusCode": 200,
                "body": json.dumps({
                    "auth_key": auth_key,
                    "expires_in": str(expiration_time)
                })
            }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"An error occurred: {str(e)}"})
        }