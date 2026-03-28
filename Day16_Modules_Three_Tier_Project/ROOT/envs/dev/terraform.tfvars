# ─────────────────────────────
# AWS Region
# ─────────────────────────────
aws_region = "ap-south-1"

# ─────────────────────────────
# VPC Subnets & AZs
# ─────────────────────────────
vpc_cidr               = "10.0.0.0/16"
vpc_name               = "dev-vpc"
public_subnet_1_cidr   = "10.0.1.0/24"
public_subnet_2_cidr   = "10.0.2.0/24"
private_subnet_1_cidr  = "10.0.3.0/24"
private_subnet_2_cidr  = "10.0.4.0/24"
private_subnet_3_cidr  = "10.0.5.0/24"
private_subnet_4_cidr  = "10.0.6.0/24"
private_subnet_5_cidr  = "10.0.7.0/24"
private_subnet_6_cidr  = "10.0.8.0/24"

availability_zone_1a = "ap-south-1a"
availability_zone_1b = "ap-south-1b"

# ─────────────────────────────
# EC2 & Bastion
# ─────────────────────────────
ami_id        = "ami-0f559c3642608c138"
instance_type = "t3.micro"
key_name      = "ssh_key"

# ─────────────────────────────
# RDS
# ─────────────────────────────
db_name     = "bookdb"
db_username = "admin"
db_password = "SuperSecretPass123"