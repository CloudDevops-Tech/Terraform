import json                                      #import json-allows you to convert Python objects to JSON strings.
def lambda_handler(event, context):              #def lambda_handler-defines the entry point for your Lambda function.
                                                 #event-Contains data passed into the Lambda function when it’s invoked (e.g., HTTP request, S3 event, or test event)
                                                 #context-Provides runtime information about the Lambda execution (like function name, memory, remaining execution time. 
#TODO implement
    return {                                      #Returns a response in JSON format, which is standard for Lambda functions triggered by API Gateway.
        'statusCode': 200,                        #statusCode: 200 → HTTP status code indicating success.
        'body': json.dumps('Hello from lambda!')  #body: json.dumps('Hello from lambda!') → The message 'Hello from lambda!' is converted to a JSON string for the response body.
    }                                            
                                                 
                                                 

