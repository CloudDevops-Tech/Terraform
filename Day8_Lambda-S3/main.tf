#Create S3 bucket to store Lambda code
resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-lambda-s3-bucket1"
}

# Upload ZIP code to S3
resource "aws_s3_object" "lambda_zip" {      #Upload Lambda deployment package (ZIP file) to S3
  bucket = aws_s3_bucket.bucket.id           #The S3 bucket where the ZIP file will be stored
  key    = "lambda/lambda_function.zip"      # The path (key) inside the bucket for the object
                                             # e.g., 'lambda/lambda_function.zip' will create a folder 'lambda' and place the file inside
  source = "lambda_function.zip"
  etag   = filemd5("lambda_function.zip")    #Terraform uses this to detect changes in the file.If the file changes, Terraform will update the S3 object
}
# IAM Role for Lambda Execution
# This role allows Lambda to assume permissions and access AWS resources
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role_tf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
# Attach Managed Policies to the IAM Role
# 1. Basic Lambda execution (CloudWatch logging)
# 2. Read-only access to S3 buckets
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
# Lambda Function Definition
# Defines the actual Lambda function, runtime, memory, timeout and the location of the code in S3
resource "aws_lambda_function" "lambda" {
  function_name = "lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"   #Entry-point in the code
  runtime       = "python3.12"
  timeout     = 900                                  #Maximum execution time in seconds (15 min
  memory_size = 128                                  #Memory allocated in MB


  #Code pulled from S3 (NOT local)
  s3_bucket = aws_s3_bucket.bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  #source_code_hash = filebase64sha256("lambda_function.zip")
   # Uncomment below if using local ZIP file instead of S3
  
}