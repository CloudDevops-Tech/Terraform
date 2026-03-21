# Create an IAM Role for Lambda execution
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"  # Name of the IAM role

  # Policy that defines who can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"        #IAM policy version
    Statement = [{
      Action = "sts:AssumeRole"   # Allow Lambda service to assume this role
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"  # Specifies that AWS Lambda can assume this role
      }
    }]
  })
}

# Attach a managed policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"  
  # This policy gives the Lambda function permissions to write logs to CloudWatch
}

# Create the AWS Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"              # Name of the Lambda function
  role          = aws_iam_role.lambda_role.arn      # IAM role ARN that Lambda assumes
  handler       = "lambda_function.lambda_handler"  # File and function inside the ZIP to execute
  runtime       = "python3.12"                      # Runtime environment for the Lambda
  timeout       = 900                               # Maximum execution time in seconds (15 minutes)
  memory_size   = 128                               # Memory allocated to the Lambda function in MB
  filename      = "lambda_function.zip"             # Local ZIP file containing Lambda code

  # Compute a hash of the ZIP file to detect changes
  source_code_hash = filebase64sha256("lambda_function.zip")
  # This ensures Terraform updates the Lambda when the code changes
  #If the ZIP changes, Terraform knows to update the Lambda automatically.
  #Without the ZIP (or some other packaging method, like S3), Lambda cannot be deployed via Terraform.
}