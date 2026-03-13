terraform {
  backend "s3" {
    bucket = "backendremotes3bucket"
    #key    = "terraform.tfstate" #if same pth already using in diff directory not a good practice to use here
    key     = "day6/terraform.tfstate" #good practice to use here
    region = "ap-south-1"
    use_lockfile = true
  }
}

