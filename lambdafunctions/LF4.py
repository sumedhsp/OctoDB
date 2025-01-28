import os
import boto3
import json
import time
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
QUERY_LOGS_TABLE = 'query_logs'
STATS_TABLE = 'query_stats'
DB_METADATA_TABLE = 'db_metadata'
INSTANCE_ID = 'i-045e576d617ec1c1e'  # Replace with your EC2 instance ID

def create_response(status_code, body):
    """Helper function to create standardized response"""
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',
        'Content-Type': 'application/json'
    }
    return {
        'statusCode': status_code,
        'headers': headers,
        'body': json.dumps(body)
    }

def lambda_handler(event, context):
    try:               
        body = json.loads(event['body'])
        db_id = event['requestContext']['authorizer']['db_id']
        tenant_id = event['requestContext']['authorizer']['tenant_id']
        query = body.get("query")

        print(db_id)

        if not query:
            return create_response(400, {"error": "Query is required"})

        db_metadata_table = dynamodb.Table(DB_METADATA_TABLE)
        response = db_metadata_table.get_item(Key={'db_id': db_id})
        db_name = response.get('Item', {}).get('db_name')
        print(db_name)
        if not db_name:
            return create_response(404, {"error": "No database found"})

        sanitized_query = sanitize_query(query)
        print(sanitized_query)
        execution_result = execute_query(db_name, sanitized_query, db_id, tenant_id)
        print(execution_result)

        return execution_result

    except ValueError as ve:
        return create_response(403, {"error": str(ve)})

    except Exception as e:
        return create_response(500, {"error": str(e)})


def sanitize_query(query):
    """
    Sanitize the SQL query by:
    1. Prohibiting multi-statement queries by rejecting any semicolons (;).
    2. Checking for schema modification attempts and prohibiting them.
    3. Restricting to only allowed operations: SELECT, INSERT, UPDATE, DELETE.
    """
    if ";" in query:
        raise ValueError("Only single queries are allowed. Remove the semicolon and try again.")

    prohibited_keywords = ["CREATE ", "ALTER ", "DROP ", "RENAME ", "PRAGMA "]

    for keyword in prohibited_keywords:
        if keyword in query.upper():
            raise ValueError(f"Prohibited operation detected: {keyword}")

    allowed_operations = ["SELECT", "INSERT", "UPDATE", "DELETE", "DESCRIBE"]
    if not any(query.strip().upper().startswith(op) for op in allowed_operations):
        raise ValueError("Only SELECT, INSERT, UPDATE, and DELETE operations are allowed.")

    return query.strip()


def execute_query(db_name, query, db_id, tenant_id):
    try:
        # Initialize SSM client
        ssm_client = boto3.client('ssm', region_name='us-east-2')
        
        # Construct command with ROW_COUNT()
        commands = [
            f"mysql -u root -proot@Pwd123 -D {db_name} -e \"{query}; SELECT ROW_COUNT() AS rowsAffected;\""
        ]

        # Send the command to EC2 instance
        response = ssm_client.send_command(
            InstanceIds=[INSTANCE_ID],
            DocumentName='AWS-RunShellScript',
            TimeoutSeconds=30,
            Parameters={'commands': commands},
            CloudWatchOutputConfig={
                'CloudWatchLogGroupName': 'my-ssm-logs',
                'CloudWatchOutputEnabled': True
            }
        )
        command_id = response['Command']['CommandId']
        time.sleep(5)  # Wait for command execution

        # Retrieve the command output
        output = ssm_client.get_command_invocation(
            CommandId=command_id,
            InstanceId=INSTANCE_ID
        )
        print("output ", output)
        if output['Status'] != 'Success':
            return create_response(500, {
                "error": "Command execution failed",
                "details": output['StandardErrorContent']
            })

        # Parse the command output
        command_output = output['StandardOutputContent']
        print(command_output)  # For debugging

        # Extract ROW_COUNT() result
        rows_affected_line = command_output.strip().splitlines()[-1]
        rows_affected = int(rows_affected_line.split("\t")[-1])  # Extract affected rows

        if query.strip().upper().startswith("SELECT") or query.strip().upper().startswith("DESCRIBE"):
            # Process SELECT query data
            rows = command_output.strip().splitlines()
            rows.pop()
            if len(rows) > 2:
                columns = rows[0].split("\t")
                data = [dict(zip(columns, row.split("\t"))) for row in rows[1:-1]]
            else:
                data = []
            log_query(db_name, query, len(data), db_id, tenant_id)  # Log SELECT operation
            return create_response(200, {
                "message": "Query executed successfully",
                "rowsAffected": len(data),
                "data": data
            })
        else:
            # Log non-SELECT operation (e.g., INSERT, UPDATE, DELETE)
            log_query(db_name, query, rows_affected, db_id, tenant_id)
            return create_response(200, {
                "message": "Operation successful",
                "rowsAffected": rows_affected
            })

    except Exception as e:
        return create_response(400, {"error": str(e)})


def log_query(db_name, query, rows_affected, db_id, tenant_id):
    """
    Logs the query and updates statistics in the DynamoDB query_stats table.
    """
    dynamodb = boto3.resource('dynamodb')
    query_logs_table = dynamodb.Table(QUERY_LOGS_TABLE)

    log_id = str(uuid.uuid4())  # 生成唯一日志 ID
    timestamp = datetime.utcnow().isoformat()

    # 确定操作类型
    if query.strip().upper().startswith("SELECT") or query.strip().upper().startswith("DESCRIBE"):
        operation_type = 'read'
    else:
        operation_type = 'write'

    # 插入查询日志
    log_item = {
        'log_id': log_id,
        'tenant_id': tenant_id,
        'db_name': db_name,
        'query': query,
        'rows_affected': rows_affected,
        'operation_type': operation_type,
        'timestamp': timestamp
    }
    query_logs_table.put_item(Item=log_item)

    # 更新统计表
    update_stats(db_id, operation_type, rows_affected)

def update_stats(db_id, operation_type, rows_affected):
    """
    Updates statistics in the DynamoDB query_stats table.
    If the table item does not exist, it creates a new item.
    """
    query_stats_table = dynamodb.Table(STATS_TABLE)

    try:
        # 查询是否已有统计数据
        response = query_stats_table.get_item(Key={'db_id': db_id})
        if 'Item' in response:
            # 表项已存在，更新统计数据
            item = response['Item']
            if operation_type == 'read':
                item['read_operations'] = item.get('read_operations', 0) + 1
                item['rows_read'] = item.get('rows_read', 0) + rows_affected
            elif operation_type == 'write':
                item['write_operations'] = item.get('write_operations', 0) + 1
                item['rows_written'] = item.get('rows_written', 0) + rows_affected

            # 更新表项
            query_stats_table.put_item(Item=item)
        else:
            # 表项不存在，创建新的统计数据
            new_item = {
                'db_id': db_id,
                'read_operations': 1 if operation_type == 'read' else 0,
                'write_operations': 1 if operation_type == 'write' else 0,
                'rows_read': rows_affected if operation_type == 'read' else 0,
                'rows_written': rows_affected if operation_type == 'write' else 0,
            }
            query_stats_table.put_item(Item=new_item)

    except Exception as e:
        print(f"Error updating stats: {e}")
