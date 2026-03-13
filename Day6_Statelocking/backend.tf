terraform {
  backend "s3" {
    bucket = "backendremotes3bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true  #dynmodb no longer required for state locking in s3 backend we can use lockfile for state locking in s3 backend
    #terraform version shouid be 1.10 above to use lockfile for state locking in s3 backend
  }
}