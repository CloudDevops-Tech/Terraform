import json

def lambda_handler(event, context):

    print("Event received:", event)

    response = {
        "message": "Hello from AWS Lambda!",
        "input_event": event
    }

    return {
        "statusCode": 200,
        "body": json.dumps(response)
    }