variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "basic-notification-topic"
}

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = "Basic Notification Topic"
}
