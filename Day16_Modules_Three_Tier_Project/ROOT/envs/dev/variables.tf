# ─────────────────────────────
# AWS Region
# ─────────────────────────────
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

# ─────────────────────────────
# VPC Subnets & AZs
# ─────────────────────────────
variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "private_subnet_3_cidr" {
  type = string
}

variable "private_subnet_4_cidr" {
  type = string
}

variable "private_subnet_5_cidr" {
  type = string
}

variable "private_subnet_6_cidr" {
  type = string
}

variable "availability_zone_1a" {
  type = string
}

variable "availability_zone_1b" {
  type = string
}

variable "allowed_ssh_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# ─────────────────────────────
# EC2 & Bastion
# ─────────────────────────────
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

# ─────────────────────────────
# RDS
# ─────────────────────────────
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_multi_az" {
  type    = bool
  default = false
}

# ─────────────────────────────
# Launch Template & ASG
# ─────────────────────────────
variable "frontend_desired_capacity" {
  type    = number
  default = 1
}

variable "frontend_min_size" {
  type    = number
  default = 1
}

variable "frontend_max_size" {
  type    = number
  default = 3
}

variable "backend_desired_capacity" {
  type    = number
  default = 1
}

variable "backend_min_size" {
  type    = number
  default = 1
}

variable "backend_max_size" {
  type    = number
  default = 3
}

variable "scale_out_target_value" {
  type    = number
  default = 80
}