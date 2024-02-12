import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('view-counter')

def lambda(event, context):
