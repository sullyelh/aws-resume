import boto3
import json

def lambda_handler(event, context):
    # Retrieve the page ID from the incoming request
    page_id = event['body']['pageId'] 

    # Init DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('resume-view-count') 
    
    try:
        # Increment view count for the page ID
        response = table.update_item(
            Key={'page_id': page_id},
            UpdateExpression="SET views = if_not_exists(views, :initial) + :val",
            ExpressionAttributeValues={':initial': 0, ':val': 1},
            ReturnValues="UPDATED_NEW"
        )
        
        # Show success
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'View count incremented successfully'})
        }
    except Exception as e:
        # Show error
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }