
resource "aws_cloudwatch_metric_alarm" "lambda_invocations_alarm" {
  alarm_name                = "zirong-info-count-breach"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "Invocations"  # You can change this to any Lambda metric (e.g., Errors, Duration)
  namespace                 = "/moviedb-api/zirong"
  period                    = 60  # 1 minute period
  statistic                 = "Sum"  # Sum of invocations
  threshold                 = 10 # Set a static threshold condition that alarms when the metric is greater than 10
  alarm_description         = "This alarm triggers when invocations exceed the threshold of 10"
  insufficient_data_actions = []

  dimensions = {
    FunctionName = "NgZiRong1984-topmovies-api"  # Lambda function name
  }

  actions_enabled = true
  alarm_actions  = [
    # Optionally, you can add SNS topic ARN for alarm actions here
    "arn:aws:sns:ap-southeast-1:255945442255:zirong-alert-topic"
  ]
}

resource "aws_sns_topic" "lambda_alarm_sns" {
  name = "zirong-alert-topic"
}

resource "aws_sns_topic_subscription" "lambda_alarm_subscription" {
  topic_arn = aws_sns_topic.lambda_alarm_sns.arn
  protocol  = "email"
  endpoint  = "ngzirong1984@gmail.com"  # Your email address for notifications
}
