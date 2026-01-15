# aws-lambda-with-terraform
Utilizes AWS Lambda and API Gateway with Terraform.

This project uses Terraform to provision all needed infrastructure, including the API Gateway REST API, resources and methods, the Lambda function, their integration, and the required IAM permissions. 

Once everything is set up, a client request hits the API Gateway endpoint and path, API Gateway invokes the Lambda function, and the Lambda handler runs the business logic and returns a response back through API Gateway to the client.

The input expected is a string and the response is the number of words, characters, and if the string is deemed too long.
