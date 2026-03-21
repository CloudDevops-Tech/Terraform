module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"   #source is terraform registry

  bucket = "s3-bucket123-terraform-registry"
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
    versioning = {
         enabled = true
    }
}

/* These inputs (bucket, acl, etc.) are defined inside the module in a file called variables.tf as
variable "bucket" {
  description = "The name of the bucket"
  type        = string
}
Inside the module, there will be a main.tf file.
That file contains actual AWS resources like:
resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = var.acl
}
*/