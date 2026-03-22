module "vpc" {
  source         = "./modules/vpc"
  cidr_block     = var.vpc_cidr
  subnet_1_cidr  = var.subnet_1_cidr
  subnet_2_cidr  = var.subnet_2_cidr
  az1            = var.az1
  az2            = var.az2
}

#SECURITY GROUPS (NETWORK CONTROL)
# Must come after VPC (needs vpc_id)
resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id

  # Allow internet → ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = module.vpc.vpc_id

  # Allow ONLY ALB → EC2
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow outbound internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ALB
# Needs VPC + subnets + ALB SG
module "alb" {
  source  = "./modules/alb"
  subnets = [module.vpc.subnet_1_id, module.vpc.subnet_2_id]
  alb_sg  = aws_security_group.alb_sg.id
  vpc_id  = module.vpc.vpc_id
}

# ASG
# Needs ALB target group + EC2 SG
module "asg" {
  source            = "./modules/asg"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnets           = [module.vpc.subnet_1_id, module.vpc.subnet_2_id]
  target_group_arn  = module.alb.target_group_arn
  ec2_sg            = aws_security_group.ec2_sg.id
}

module "ec2" {
   source        = "./modules/ec2"
   ami_id        = "ami-0f559c3642608c138" # Replace with valid AMI
   instance_type = "t3.micro"
   subnet_1_id     = module.vpc.subnet_1_id
}

module "rds" {
  source          = "./modules/rds"
  subnet_1_id     = module.vpc.subnet_1_id
  subnet_2_id     = module.vpc.subnet_2_id
  instance_class  = var.db_instance_class
  db_name         = var.db_name
  db_user         = var.db_user
  db_password     = var.db_password
}

module "s3" {
  source = "./modules/s3"
  bucket = var.bucket_name
}

module "lambda" {
  source = "./modules/lambda"

  function_name = var.lambda_function_name
  description   = var.lambda_description
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  source_path   = var.lambda_source_path

  tags = var.lambda_tags
}



#Example EC2
#This EC2 is not required for CloudWatch itself, but it is required for the alarm you created
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
   tags = {
    Name = "cw-ec2"
  }
}

#SNS Module
module "sns" {
  source = "./modules/sns"
  topic_name = var.sns_topic_name
  email      = var.sns_email
}

#CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"

  log_group_name   = var.log_group_name
  log_retention    = var.log_retention
  alarm_name       = var.alarm_name
  instance_id      = aws_instance.example.id
  dashboard_name   = var.dashboard_name
  sns_topic_arn    = module.sns.topic_arn   #connect SNS here
}
# EC2 → CloudWatch Metric → Alarm → SNS → Email