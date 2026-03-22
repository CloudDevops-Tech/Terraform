module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime

  source_path = var.source_path

  tags = var.tags
}