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
resource "aws_db_subnet_group" "rds_replica_db_subnet_group" {
  name = "rds_replica_db_subnet_group"
  description = "DB subnet group for RDS"
  subnet_ids = [aws_subnet.rds_subnet1.id, aws_subnet.rds_subnet2.id]
  tags = {
    Name = "rds_replica_db_subnet_group"
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

#RDS MySql primary-db
resource "aws_db_instance" "mysql" {
  identifier              = "primary-database"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  db_name                 = "mydb"
  username                = "admin"
  password                = "cloud123"
  #manage_master_user_password = false     
  #manage_master_user_password should be true for Secret Manager managed credentials
  #manage_master_user_password = true supports only single db.
  #manage_master_user_password should be disabled for Read Replica
  db_subnet_group_name    = aws_db_subnet_group.rds_replica_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 1              #Required for read replicas
  deletion_protection     = false
  apply_immediately       = true
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring.arn

  tags = {
     Name = "Primary-Database"
    }
}

#Read Replica
resource "aws_db_instance" "replica" {
  identifier              = "rdsdb-replica"
  replicate_source_db     = aws_db_instance.mysql.arn
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.rds_replica_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  auto_minor_version_upgrade = true
  monitoring_interval = 60         #Enhanced Monitoring-Data collected every 60 seconds
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn 
  #Enhanced Monitoring  
  #RDS use this role to push monitoring data
  #RDS → send data → CloudWatch
  depends_on = [aws_db_instance.mysql]   #ensures primary DB exists before replica creation

  tags = {
  Name = "Read-Replica"
}
}

#IAM Role - rds monitoring role
resource "aws_iam_role" "rds_monitoring" {   #Allow RDS to send OS-level metrics to CloudWatch
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}
#Give this role permission to send monitoring data to CloudWatch
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole" 
  #AWS Managed Policy contains permissions like logs:PutLogEvents,logs:CreateLogStream,cloudwatch:PutMetricData
}


#High availability (Multi-AZ subnets)
#Scalability (Read replica)
#Security (SG + private DB)
#Observability (Enhanced Monitoring)