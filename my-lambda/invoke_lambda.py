# Invokes the lambda function from lambda_function.py with expected payload

import boto3
import json

# Use your AWS CLI profile
session = boto3.Session(profile_name="klastra")
lambda_client = session.client("lambda")

# Example payload
payload = {
    "body": {
        "text": "I am Boo!"
    }
}

# Invoke the Lambda
response = lambda_client.invoke(
    FunctionName="my-lambda",
    Payload=json.dumps(payload)
)

# Parse and pretty-print the response
result = json.load(response['Payload'])
print(json.dumps(result, indent=2))