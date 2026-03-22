#Create SNS Topic
resource "aws_sns_topic" "topic" {
  name = var.topic_name
}

#Email Subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email
}

# Output ARN
output "topic_arn" {
  value = aws_sns_topic.topic.arn
}