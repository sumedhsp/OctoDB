import json
import boto3

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tenants')  # Replace with your DynamoDB table name

def lambda_handler(event, context):
    # TODO implement
    print("Event: ")
    print(event)

    if 'authorizationToken' not in event:
        raise ValueError("Missing 'authorizationToken' in the event")

    auth_key = event['authorizationToken']
    print(f"Authorization token: {auth_key}")

    # Fetch item from DynamoDB
    # response = table.scan()
    # items = response['Items']
    # auth = "Deny"
    # email = None
    # for item in items:
    #     if item['token'] == token:
    #         auth = "Allow"
    #         email = item['email']
    #         break
    response = table.scan(
        FilterExpression='#auth_key = :auth_key',
        ExpressionAttributeNames={
            '#auth_key': 'auth_key'  # Alias for reserved keyword "token"
        },
        ExpressionAttributeValues={
            ':auth_key': auth_key
    }
    )

    auth = "Deny"
    email = None
    tenant_id = None
    db_id = None
    is_admin = None
    if response['Items']:
        print(response['Items'])
        auth = "Allow"
        tenant_id = response['Items'][0]['tenant_id']
        db_id = response['Items'][0]['db_id']
        email = response['Items'][0]['email']
        is_admin = response['Items'][0]['is_admin']
    
    #3 - Construct and return the response
    authResponse = { 
        "principalId": tenant_id, 
        "policyDocument": 
            { 
                "Version": "2012-10-17", 
                "Statement": [
                    {
                        "Action": "execute-api:Invoke", 
                        "Resource": [
                            "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/*",
                            "arn:aws:execute-api:us-east-2:571600864139:2dr3wn94t1/*/POST/migrate"
                            ], 
                        "Effect": auth
                    }
                ] 
            },
        "context": {
            "tenant_id": tenant_id,
            "db_id": db_id,
            "is_admin": is_admin,
            "email": email
        }
    }
    print(authResponse)
    return authResponse
