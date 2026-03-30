#Instance Import
resource "aws_instance" "name" {
    ami = "ami-0931307dcdc2a28c9"
    instance_type = "t3.micro"
    tags = {
      Name = "test"
    }
}

#S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "testbucketversioning9"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}



