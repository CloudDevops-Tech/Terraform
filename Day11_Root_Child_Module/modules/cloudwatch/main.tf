#Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.log_group_name
  retention_in_days = var.log_retention
}

#Log Stream
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "app-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

#CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_description = "CPU > 70%"

  alarm_actions = [var.sns_topic_arn]   #SNS connected here
}

#Dashboard
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", var.instance_id ]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "EC2 CPU Usage"
        }
      }
    ]
  })
}