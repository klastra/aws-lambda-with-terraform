import json


# Once we zip this file, this will be a "deployable package"
# AWS Lambda requires code to be uploaded as a single compressed package
def lambda_handler(event, context):
    # Support both API Gateway HTTP events and CLI test events
    body = event.get("body")

    # If API Gateway passes body as JSON string, parse it
    if isinstance(body, str):
        try:
            body = json.loads(body)
        except json.JSONDecodeError:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid JSON"})
            }

    text = body.get("text") if body else None

    if not text:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "You must provide 'text' in the body."})
        }

    result = {
        "text": text,
        "characters": len(text),
        "words": len(text.split()),
        "is_long": len(text) > 100
    }

    return {
        "statusCode": 200,
        "body": json.dumps(result)
    }
