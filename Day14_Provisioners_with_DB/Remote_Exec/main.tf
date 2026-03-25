# VARIABLES
variable "vpc_id" {
  description = "VPC where EC2 and RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for RDS and EC2"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
  default     = "ssh_key"
}

variable "pem_path" {
  description = "Local path to private key (Windows use forward slashes)"
  type        = string
  default     = "C:/Users/user/Downloads/ssh_key.pem"
}


# SECURITY GROUPS
# EC2 Security Group (SSH access)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH to EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group (MySQL access from EC2 only)
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL from EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]  # allow EC2 to RDS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 INSTANCE
resource "aws_instance" "sql_runner" {
  ami                         = "ami-0f559c3642608c138" # Amazon Linux 2
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = var.subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "SQL Runner"
  }

  # Install MySQL client immediately after instance launch
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mysql"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.pem_path)
      host        = self.public_ip
    }
  }
}


# SECRETS MANAGER FOR RDS CREDENTIALS
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "rds-credentials"
}

resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "MyRdsPassword123!"
  })
}

# RDS INSTANCE
# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}

# MySQL RDS instance
resource "aws_db_instance" "mysql_rds" {
  identifier             = "mysql-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "mydb"  # initial database
  username               = jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"]
  password               = jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}


# REMOTE SQL EXECUTION (init.sql)
resource "null_resource" "remote_sql_exec" {
  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.pem_path)
    host        = aws_instance.sql_runner.public_ip
  }

  # Copy SQL file to EC2
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  # Execute SQL on RDS from EC2
  # MySQL client already installed from EC2 provisioner
  provisioner "remote-exec" {
    inline = [
      "mysql -h ${aws_db_instance.mysql_rds.address} -u ${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"]} -p${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"]} < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp()  # ensures it runs every apply
  }
}