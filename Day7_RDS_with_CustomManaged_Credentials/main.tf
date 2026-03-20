#create a vpc for rds
resource "aws_vpc" "rds_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "rds vpc"
    }
}
#create two az subnet for rds
resource "aws_subnet" "rds_subnet1" {
    vpc_id = aws_vpc.rds_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "rds_Subnet1"
    }  
}
resource "aws_subnet" "rds_subnet2" {
    vpc_id = aws_vpc.rds_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "rds_Subnet2"
    }
}
#create a db subnet group for rds
resource "aws_db_subnet_group" "rds_db_subnet_group-1" {
  name = "rds_db_subnet_group-1"
  description = "DB subnet group for RDS"
  subnet_ids = [aws_subnet.rds_subnet1.id, aws_subnet.rds_subnet2.id]
  tags = {
    Name = "rds_db_subnet_group-1"
  }
}

#create a security group for rds
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  description = "Security group for RDS"
  vpc_id = aws_vpc.rds_vpc.id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds_sg"
  }
}

# RDS MySQL (Custom Managed Credentials)
resource "aws_db_instance" "mysql" {
  identifier = "primary-db-1"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"
  db_name  = "mydb"
  username = "admin"
  password = "Cloud123"                 #Use variables in real projects
  #manage_master_user_password = false
  #Dont use manage_master_user_password for custom managed credentials
  db_subnet_group_name   = aws_db_subnet_group.rds_db_subnet_group-1.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  multi_az            = false
  backup_retention_period = 1 #1 for free tier
  skip_final_snapshot     = true
  deletion_protection     = true

  tags = {
    Name = "Primary-database-1"
  }
}