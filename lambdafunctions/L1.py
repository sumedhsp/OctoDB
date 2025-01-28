# import json
# import boto3
# from datetime import datetime
# import re
# import uuid

# def extract_timestamp(log_message):
#     timestamp_match = re.search(r'(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})', log_message)
#     if timestamp_match:
#         return timestamp_match.group(1)
#     return None

# def process_log_entry(log_text):
#     try:
#         # Parse the message body as JSON
#         message_data = json.loads(log_text)
        
#         timestamp = None
#         logs = None
        
#         # Extract timestamp and logs from stderr or stdout
#         if 'stderr' in message_data:
#             timestamp = extract_timestamp(message_data['stderr'])
#             logs = message_data['stderr']
#         elif 'stdout' in message_data:
#             timestamp = extract_timestamp(message_data['stdout'])
#             logs = message_data['stdout']
            
#         if timestamp and logs:
#             entry_data = {
#                 'log_id': str(uuid.uuid4()),
#                 'tenant_id': message_data['tenant_id'],
#                 'create_timestamp': timestamp,
#                 'logs': logs
#             }
#             return [entry_data]
            
#     except json.JSONDecodeError as e:
#         print(f"Error parsing JSON entry: {e}")
#         print(f"Problematic entry: {log_text}")
#     except Exception as e:
#         print(f"Error processing entry: {str(e)}")
#         print(f"Problematic entry: {log_text}")
    
#     return []

# def lambda_handler(event, context):
#     print("Lambda function started")
#     print(f"Received event: {json.dumps(event, indent=2)}")
    
#     dynamodb = boto3.resource('dynamodb')
#     table = dynamodb.Table('log_table')
    
#     processed_count = 0
    
#     try:
#         # Process each record from the SQS event
#         for record in event['Records']:
#             print(f"Processing message ID: {record['messageId']}")
#             message_body = record['body']
            
#             # Process the log entry
#             processed_entries = process_log_entry(message_body)
            
#             # Store each processed entry in DynamoDB
#             for entry in processed_entries:
#                 try:
#                     print(f"Storing entry in DynamoDB: {entry['log_id']}")
#                     table.put_item(Item=entry)
#                     processed_count += 1
#                     print(f"Successfully stored entry: {entry['log_id']}")
#                 except Exception as e:
#                     print(f"Error storing in DynamoDB: {str(e)}")
        
#         return {
#             'statusCode': 200,
#             'body': json.dumps(f'Successfully processed {processed_count} log entries')
#         }
        
#     except Exception as e:
#         print(f"Error in lambda_handler: {str(e)}")
#         return {
#             'statusCode': 500,
#             'body': json.dumps(f'Error: {str(e)}')
#         }


import json
import boto3
from datetime import datetime
import re
import time
import uuid

def extract_timestamp(log_message):
    timestamp_match = re.search(r'(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})', log_message)
    if timestamp_match:
        return timestamp_match.group(1)
    return None

def process_log_entry(log_text):
    try:
        # Parse the message body as JSON
        message_data = json.loads(log_text)
        print('mesaage_data', message_data)
        timestamp = None
        logs = None
        
        # Extract timestamp and logs from stderr or stdout
        if 'stderr' in message_data:
            timestamp = extract_timestamp(message_data['stderr'])
            logs = message_data['stderr']
        elif 'stdout' in message_data:
            timestamp = extract_timestamp(message_data['stdout'])
            logs = message_data['stdout']
        elif 'event' in message_data:
            timestamp = message_data['timestamp']
            logs = message_data['event']
            
        if timestamp and logs:
            entry_data = {
                'log_id': str(uuid.uuid4()),  
                'tenant_id': message_data['tenant_id'],
                'create_timestamp': timestamp,
                'logs': logs
            }
            return [entry_data]
            
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON entry: {e}")
        print(f"Problematic entry: {log_text}")
    except Exception as e:
        print(f"Error processing entry: {str(e)}")
        print(f"Problematic entry: {log_text}")
    
    return []

def lambda_handler(event, context):
    print("Lambda function started")
    print(f"Received event: {json.dumps(event, indent=2)}")
    
    # Initialize AWS clients
    dynamodb = boto3.resource('dynamodb')
    sqs = boto3.client('sqs')
    table = dynamodb.Table('log_table')
    queue_url = "https://sqs.us-east-2.amazonaws.com/571600864139/log_queue"
    
    processed_count = 0
    
    try:
        # Process each record from the SQS event
        for record in event['Records']:
            print(f"Processing message ID: {record['messageId']}")
            message_body = record['body']
            
            # Process the log entry
            processed_entries = process_log_entry(message_body)
            print(processed_entries)
            # Store each processed entry in DynamoDB
            dynamo_success = True  # Initialize flag
            for entry in processed_entries:
                try:
                    print(f"Storing entry in DynamoDB: {entry['log_id']}")
                    table.put_item(Item=entry)
                    processed_count += 1
                    print(f"Successfully stored entry: {entry['log_id']}")
                    dynamo_success = True
                except Exception as e:
                    print(f"Error storing in DynamoDB: {str(e)}")
                    dynamo_success = False
            
            # Delete SQS message only if DynamoDB storage was successful
            if dynamo_success:
                try:
                    sqs.delete_message(
                        QueueUrl=queue_url,
                        ReceiptHandle=record['receiptHandle']
                    )
                    print(f"Successfully deleted message: {record['messageId']}")
                except Exception as e:
                    print(f"Error deleting SQS message: {str(e)}")
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Successfully processed {processed_count} log entries')
        }
        
    except Exception as e:
        print(f"Error in lambda_handler: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }