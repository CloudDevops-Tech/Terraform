#Create an IAM policy that allows access to S3
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Allow EC2 to access S3"
#Define permissions using JSON
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        #Resources (bucket + all objects inside it)
        Resource = [
          "arn:aws:s3:::my-bucket",
          "arn:aws:s3:::my-bucket/*"
        ]
      }
    ]
  })
}

#Create IAM role that EC2 will assume
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-role"
#Trust policy: allows EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
#Attach the S3 policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
  depends_on = [ aws_iam_policy.s3_access_policy ]     #Explicit dependency
}

#Create instance profile (required to attach IAM role to EC2)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}
#Create EC2 instance and attach IAM role via instance profile
resource "aws_instance" "name" {
  instance_type = "t3.micro"
  ami           = "ami-0f559c3642608c138"
  tags = {
    Name= "ec2_dependency"
  }

  # Attach IAM role to EC2
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

}
#Create S3 bucket
resource "aws_s3_bucket" "name" {
  bucket = "s3-dependency-bucket"
  depends_on = [ aws_instance.name ]  #Do NOT create this resource until the EC2 instance (aws_instance.name) is fully created
}
#Instance must be created before S3 because we declared dependency block
#dependency block is used to explicitly specify the order of resource creation. In this case, it ensures that the EC2 instance is created before the S3 bucket. This is important because the EC2 instance needs to assume the IAM role that has permissions to access the S3 bucket. By using depends_on, we can avoid potential issues where the S3 bucket is created before the EC2 instance, which could lead to permission errors when the EC2 instance tries to access the bucket.
#so here after create the EC2 instance, it will create the S3 bucket. This way, we ensure that the necessary IAM role and permissions are in place before the S3 bucket is created, allowing for proper access control and functionality.
