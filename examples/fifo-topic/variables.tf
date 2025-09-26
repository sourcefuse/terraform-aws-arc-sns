variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "topic_name" {
  description = "Name of the SNS FIFO topic (without .fifo suffix)"
  type        = string
  default     = "order-processing-topic"
}

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = "Order Processing FIFO Topic"
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication"
  type        = bool
  default     = true
}
