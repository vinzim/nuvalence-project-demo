# This program prints Hello, world!
import os

API_KEY = os.environ["api_key"]
DB_USER = os.environ["db_user"]
DB_PASS = os.environ["db_pass"]

def lambda_handler(event, context):
    message = 'Hello {} {}!'.format("to the", "world")  
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': message,
        "isBase64Encoded": False
    }

def lambda_health(event,context):
    message = 'I am healthy'  
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': message,
        "isBase64Encoded": False
    }