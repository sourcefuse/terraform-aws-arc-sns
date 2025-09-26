variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Bucket Name"
}
variable "acl" {
  type        = string
  description = "ACL value"
}


variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "s3-sns-bucket-events"
}

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = null
}

variable "s3_events" {
  description = "List of S3 events to trigger SNS notifications"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}
