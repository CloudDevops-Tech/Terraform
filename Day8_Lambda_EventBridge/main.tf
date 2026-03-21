#Create the Lambda function
resource "aws_lambda_function" "example" {

  function_name = "example-scheduled-lambda"   # Name of the Lambda function
  role = aws_iam_role.lambda_exec.arn          # IAM role that Lambda will assume
  handler = "lambda_function.lambda_handler"   # File name + function name inside your code
                                               # (lambda_function.py → lambda_handler function)
  runtime = "python3.9"                        # Runtime environment for Lambda

  timeout = 900                                # Maximum execution time (in seconds) 900 sec = 15 minutes (max allowed)
  memory_size = 128                            # Memory allocated to Lambda (in MB)
  filename = "lambda_function.zip"             # Path to your zipped Lambda code
  source_code_hash = filebase64sha256("lambda_function.zip")
  # Used by Terraform to detect changes in code and update Lambda automatically
}

#Create IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
name = "lambda_exec_role"                      #Name of IAM role
assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"                #Allows assuming the role
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"       #Only Lambda service can assume this role
      }
    }]
  })
}

#Attach basic execution policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_logging" {
role = aws_iam_role.lambda_exec.name             # Attach policy to this role
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  # This policy allows Lambda to:
  # - Write logs to CloudWatch
}


#Create EventBridge rule (schedule trigger)
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
name = "every-five-minutes"                        # Rule name
description = "Trigger Lambda every 5 minutes"     #Schedule expression (cron format)
schedule_expression = "cron(0/5 * * * ? *)"        #Means: run every 5 minutes #(alternative: rate(5 minutes))
}

#Connect EventBridge rule to Lambda (target)
resource "aws_cloudwatch_event_target" "invoke_lambda" {
rule = aws_cloudwatch_event_rule.every_five_minutes.name     #Which rule triggers the target
target_id = "lambda"                                         #Identifier for this target
arn = aws_lambda_function.example.arn                        #Which Lambda function should be triggered
}

#Give permission to EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
statement_id = "AllowExecutionFromEventBridge"                  #Unique ID for permission
action = "lambda:InvokeFunction"                                #Allow invoking Lambda
function_name = aws_lambda_function.example.function_name
principal = "events.amazonaws.com"                              #EventBridge service
source_arn = aws_cloudwatch_event_rule.every_five_minutes.arn   #Only this rule can trigger the Lambda
}