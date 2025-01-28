import boto3
import json
import decimal  # 添加这行导入
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')

USERS_TABLE = 'tenants'
DB_METADATA_TABLE = 'db_metadata'
TABLE_METADATA_TABLE = 'table_metadata'
LOG_TABLE = 'log_table'
QUERY_LOGS_TABLE = 'query_logs'
QUERY_STATS_TABLE = 'query_stats'
SENSITIVE_FIELDS = ['db_id', 'log_id', 'tenant_id', 'auth_key', 'password_hash', 'db_name']

# 自定义 JSON encoder
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return str(obj)  # 或者 float(obj) 如果你想要浮点数
        return super(DecimalEncoder, self).default(obj)

def filter_sensitive_data(data):
    """Remove sensitive information from the response data"""
    if isinstance(data, dict):
        return {k: filter_sensitive_data(v) for k, v in data.items() 
               if not any(sensitive in k.lower() for sensitive in SENSITIVE_FIELDS)}
    elif isinstance(data, list):
        return [filter_sensitive_data(item) for item in data]
    else:
        return data


# def create_response(status_code, body):
#     """Helper function to create standardized response"""
#     headers = {
#         'Access-Control-Allow-Origin': '*',
#         'Access-Control-Allow-Headers': 'Content-Type,Authorization',
#         'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',
#         'Content-Type': 'application/json'
#     }
#     return {
#         'statusCode': status_code,
#         'headers': headers,
#         'body': json.dumps(body, cls=DecimalEncoder)  # 使用自定义 encoder
#     }

# 修改 create_response 函数
def create_response(status_code, body):
    """Helper function to create standardized response with filtered data"""
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET',
        'Content-Type': 'application/json'
    }
    
    # 过滤敏感数据
    filtered_body = filter_sensitive_data(body)
    
    return {
        'statusCode': status_code,
        'headers': headers,
        'body': json.dumps(filtered_body, cls=DecimalEncoder)
    }

def lambda_handler(event, context):
    users_table = dynamodb.Table(USERS_TABLE)
    db_metadata_table = dynamodb.Table(DB_METADATA_TABLE)
    table_metadata_table = dynamodb.Table(TABLE_METADATA_TABLE)
    log_table = dynamodb.Table(LOG_TABLE)
    query_logs_table = dynamodb.Table(QUERY_LOGS_TABLE)
    query_stats_table = dynamodb.Table(QUERY_STATS_TABLE)

    print(event)
    
    try:
        # 解析API Gateway传来的body
        if isinstance(event.get('body'), str):
            body = json.loads(event.get('body', '{}'))
        else:
            body = event.get('body', {})

        action = body.get('action')
        user_id = event['requestContext']['authorizer']['tenant_id']
        db_id = event['requestContext']['authorizer']['db_id']
        table_id = body.get('table_id')

        print(action, user_id, db_id, table_id)

    except Exception as e:
        return create_response(400, {
            'error': f"Invalid request body: {str(e)}"
        })

    try:
        if action == "get_user_info":
            response = users_table.get_item(Key={'tenant_id': user_id})
            if 'Item' not in response:
                return create_response(404, {
                    'error': f"User {user_id} not found"
                })
            return create_response(200, response['Item'])

        elif action == "get_user_databases":
            response = users_table.get_item(Key={'tenant_id': user_id})
            print(response)
            if 'Item' not in response:
                return create_response(404, {
                    'error': f"User {user_id} not found"
                })
            db_ids = response['Item'].get('db_id', [])
            print(db_ids)
            return create_response(200, {
                'db_ids': db_ids
            })

        elif action == "get_database_info":
            response = db_metadata_table.get_item(Key={'db_id': db_id})
            if 'Item' not in response:
                return create_response(404, {
                    'error': f"Database {db_id} not found"
                })
            return create_response(200, response['Item'])

        elif action == "get_database_tables":
            response = table_metadata_table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr('db_id').eq(db_id)
            )
            tables = [[item['table_name'],item['schema_version']] for item in response['Items']]
            return create_response(200, {
                'Tables': tables
            })

        # elif action == "get_table_info":
        #     response = table_metadata_table.get_item(Key={'table_id': table_id})
        #     if 'Item' not in response:
        #         return create_response(404, {
        #             'error': f"Table {table_id} not found"
        #         })
        #     return create_response(200, response['Item'])

        elif action == "get_table_info":
            table_name = body.get('table_name')  # 从请求体获取 table_name
            if not table_name:
                return create_response(400, {
                    'error': "table_name is required"
                })
            
            try:
                response = table_metadata_table.scan(
                    FilterExpression=boto3.dynamodb.conditions.Attr('table_name').eq(table_name) & 
                                boto3.dynamodb.conditions.Attr('db_id').eq(db_id)
                )
                
                if not response['Items']:
                    return create_response(404, {
                        'error': f"Table {table_name} not found in database {db_id}"
                    })
                
                # 返回第一个匹配的项
                return create_response(200, response['Items'][0])
                
            except ClientError as e:
                return create_response(500, {
                    'error': f"DynamoDB error: {e.response['Error']['Message']}"
                })
        
        elif action == "get_log_table":
            # 从请求体获取分页参数
            # limit = int(body.get('limit', 10))  
            try:
                log_response = log_table.scan(
                    FilterExpression=Attr("tenant_id").eq(user_id)
                )
            except Exception as e:
                return e
            print(log_response)
            # if response.get('Items'):
            result = {
                'logs': log_response['Items'],
                'count': len(log_response['Items'])
            }
            print(result)
            return create_response(200, result)
            # last_evaluated_key = body.get('last_evaluated_key')

            
            # # 构建查询参数
            # query_params = {
            #     'IndexName': 'tenant_id-index',  # 假设有一个 tenant_id 的二级索引
            #     'KeyConditionExpression': boto3.dynamodb.conditions.Key('tenant_id').eq(user_id),
            #     'Limit': limit
            # }
            
            # # 如果有 last_evaluated_key，添加到查询参数中
            # if last_evaluated_key:
            #     query_params['ExclusiveStartKey'] = last_evaluated_key
            
            # # 如果没有 tenant_id 索引，则使用 scan + filter
            # try:
            #     response = log_table.query(**query_params)
            # except ClientError as e:
            #     if e.response['Error']['Code'] == 'ValidationException':
            #         # 如果索引不存在，退回到使用 scan
            #         scan_params = {
            #             'FilterExpression': boto3.dynamodb.conditions.Attr('tenant_id').eq(user_id),
            #             'Limit': limit
            #         }
            #         if last_evaluated_key:
            #             scan_params['ExclusiveStartKey'] = last_evaluated_key
            #         response = log_table.scan(**scan_params)
            
            # result = {
            #     'items': response['Items'],
            #     'count': len(response['Items'])
            # }
            
            # # 如果有更多数据，返回 LastEvaluatedKey
            # if 'LastEvaluatedKey' in response:
            #     result['last_evaluated_key'] = response['LastEvaluatedKey']
            
            # return create_response(200, result)

        elif action == "get_query_logs":
            # 获取分页参数
            limit = int(body.get('limit', 10))  # 默认每页10条
            last_evaluated_key = body.get('last_evaluated_key')
            
            # 如果有 tenant_id 索引
            try:
                query_params = {
                    'IndexName': 'tenant_id-index',  # 假设有一个 tenant_id 的二级索引
                    'KeyConditionExpression': boto3.dynamodb.conditions.Key('tenant_id').eq(user_id),
                    'Limit': limit,
                    'ScanIndexForward': False  # 默认降序，最新的记录在前
                }
                
                if last_evaluated_key:
                    query_params['ExclusiveStartKey'] = last_evaluated_key
                    
                response = query_logs_table.query(**query_params)
            
            except ClientError as e:
                if e.response['Error']['Code'] == 'ValidationException':
                    # 如果没有索引，使用 scan + filter
                    scan_params = {
                        'FilterExpression': boto3.dynamodb.conditions.Attr('tenant_id').eq(user_id),
                        'Limit': limit
                    }
                    
                    if last_evaluated_key:
                        scan_params['ExclusiveStartKey'] = last_evaluated_key
                        
                    response = query_logs_table.scan(**scan_params)
            
            result = {
                'logs': response['Items'],
                'count': len(response['Items'])
            }
            
            # 如果有更多数据，返回 LastEvaluatedKey
            if 'LastEvaluatedKey' in response:
                result['last_evaluated_key'] = response['LastEvaluatedKey']
            
            return create_response(200, result)
            
        elif action == "get_query_stats":
            # 使用 db_id 作为主键查询
            try:
                response = query_stats_table.get_item(
                    Key={'db_id': db_id}
                )
                
                if 'Item' not in response:
                    return create_response(200, {
                        'error': f"Statistics for database {db_id} not found"
                    })
                    
                return create_response(200, {
                    'stats': response['Item']
                })
                
            except ClientError as e:
                return create_response(500, {
                    'error': f"DynamoDB error: {e.response['Error']['Message']}"
                })
            except Exception as e:
                return create_response(500, {
                    'error': f"Internal error: {str(e)}"
                })

        else:
            return create_response(400, {
                'error': f"Invalid action '{action}' specified. Supported actions are: get_user_info, get_user_databases, get_database_info, get_database_tables, get_table_info"
            })

    except ClientError as e:
        return create_response(500, {
            'error': f"DynamoDB error: {e.response['Error']['Message']}"
        })
    except Exception as e:
        return create_response(500, {
            'error': f"Internal error: {str(e)}"
        })