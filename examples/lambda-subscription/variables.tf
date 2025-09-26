variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "lambda-subscription-topic"
}

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = "Lambda Subscription Topic"
}

variable "filter_event_types" {
  description = "List of event types to filter for"
  type        = list(string)
  default     = ["user_signup", "user_login", "password_reset"]
}
