variable "region" {
  description = "AWS region"
  type        = string
}

#VPC VARIABLES
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_1_cidr" {
  description = "Subnet 1 CIDR"
  type        = string
}

variable "subnet_2_cidr" {
  description = "Subnet 2 CIDR"
  type        = string
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
}

# EC2 / ASG VARIABLES
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

#RDS VARIABLES
variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

#Lambda Variables
variable "lambda_function_name" {
  type = string
}

variable "lambda_description" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_source_path" {
  type = string
}

variable "lambda_tags" {
  type = map(string)
}

#S3 VARIABLES
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

# CloudWatch
variable "log_group_name" {}
variable "log_retention" {}
variable "alarm_name" {}
variable "dashboard_name" {}

# SNS
variable "sns_topic_name" {}
variable "sns_email" {}