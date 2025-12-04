import json
import logging
import os
import boto3
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB Client (Outside handler for performance)
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    logger.info("Event received: %s", json.dumps(event))
    
    for record in event.get('Records', []):
        bucket_name = record['s3']['bucket']['name']
        file_name = record['s3']['object']['key']
        size = record['s3']['object']['size']
        
        # Write to DynamoDB
        try:
            response = table.put_item(
                Item={
                    'ImageID': file_name,
                    'Bucket': bucket_name,
                    'Size': size,
                    'ProcessTime': str(uuid.uuid4())
                }
            )
            logger.info(f"Metadata saved for {file_name}")
        except Exception as e:
            logger.error(f"Error saving to DB: {str(e)}")
            raise e
            
    return {'statusCode': 200, 'body': 'Metadata processed'}