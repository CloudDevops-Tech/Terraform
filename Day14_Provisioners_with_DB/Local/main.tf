# Security Group for MySQL
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# RDS Instance
resource "aws_db_instance" "mysql_rds" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = var.db_password
  db_name                 = "dev"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
}

#Use null_resource to execute the SQL script from your local machine.
resource "null_resource" "db_init" {
  depends_on = [aws_db_instance.mysql_rds]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for DB to be ready..."
      sleep 60     
      mysql -h ${aws_db_instance.mysql_rds.address} -u admin -p${var.db_password} dev < init.sql
    EOT
#It waits (`sleep 60`) to give the RDS database enough time to fully start so your SQL command doesn’t fail due to early connection.
#Terraform creates RDS instance
#AWS says: “Created”
#But internally:
#MySQL is still starting
#Storage attaching
#Network initializing
#This can take 30–120 seconds
  }

  triggers = {
    script_hash = filemd5("init.sql")
  }
}