terraform {
  backend "s3" {
    bucket = "backendremotes3bucket"
    #key    = "terraform.tfstate" #if same pth already using in diff directory not a good practice to use here
    key     = "day6/terraform.tfstate" #good practice to use here
    region = "ap-south-1"
    use_lockfile = true
  }
}
#here we are using the same bucket but different key for different days so that we can have separate state files for each day.
#we can also have a common state file for all the days if we want to use the same state file for all the days then we can use the same key for all the days.
#if we use common s3 path for two diff directories you may destory or modify existing resources.

