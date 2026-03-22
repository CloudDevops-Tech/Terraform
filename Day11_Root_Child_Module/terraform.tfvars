region = "ap-south-1"

#VPC
vpc_cidr      = "10.0.0.0/16"
subnet_1_cidr = "10.0.1.0/24"
subnet_2_cidr = "10.0.2.0/24"
az1           = "ap-south-1a"
az2           = "ap-south-1b"

# EC2 / ASG
ami_id        = "ami-0f559c3642608c138"
instance_type = "t3.micro"

#RDS
db_instance_class = "db.t3.micro"
db_name           = "mydb"
db_user           = "admin"
db_password       = "Admin12345"

#Lambda
lambda_function_name = "my-lambda1"
lambda_description   = "My awesome lambda function"
lambda_handler       = "index.lambda_handler"
lambda_runtime       = "python3.12"
lambda_source_path   = "../src/lambda-function1"

lambda_tags = {
  Name = "my-lambda1"
}

#S3
bucket_name = "rootchild-S3Bucket-123"

# CloudWatch
log_group_name = "/app/logs"
log_retention  = 7
alarm_name     = "high-cpu-alarm"
dashboard_name = "my-dashboard"
# SNS
sns_topic_name = "my-alert-topic"
sns_email      = "your-email@example.com"