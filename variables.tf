variable "name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "use_name_prefix" {
  description = "Determines whether name is used as a prefix"
  type        = bool
  default     = false
}

variable "display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics"
  type        = bool
  default     = false
}

variable "fifo_throughput_scope" {
  description = "Enables higher throughput for FIFO topics by adjusting the scope of deduplication. Valid values: Topic, MessageGroup"
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null ? true : contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "Valid values for fifo_throughput_scope are: Topic, MessageGroup."
  }
}

variable "archive_policy" {
  description = "The message archive policy for FIFO topics"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The SNS delivery policy"
  type        = string
  default     = null
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON"
  type        = string
  default     = null
}

variable "signature_version" {
  description = "The signature version corresponds to the hashing algorithm used while creating the signature of the notifications"
  type        = number
  default     = null
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic"
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null ? true : contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "Valid values for tracing_config are: PassThrough, Active."
  }
}

# Feedback variables using object pattern
variable "application_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type = object({
    failure_role_arn    = optional(string)
    success_role_arn    = optional(string)
    success_sample_rate = optional(number)
  })
  default = {}

  validation {
    condition = var.application_feedback.success_sample_rate == null ? true : (
      var.application_feedback.success_sample_rate >= 0 &&
      var.application_feedback.success_sample_rate <= 100
    )
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "http_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type = object({
    failure_role_arn    = optional(string)
    success_role_arn    = optional(string)
    success_sample_rate = optional(number)
  })
  default = {}

  validation {
    condition = var.http_feedback.success_sample_rate == null ? true : (
      var.http_feedback.success_sample_rate >= 0 &&
      var.http_feedback.success_sample_rate <= 100
    )
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "lambda_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type = object({
    failure_role_arn    = optional(string)
    success_role_arn    = optional(string)
    success_sample_rate = optional(number)
  })
  default = {}

  validation {
    condition = var.lambda_feedback.success_sample_rate == null ? true : (
      var.lambda_feedback.success_sample_rate >= 0 &&
      var.lambda_feedback.success_sample_rate <= 100
    )
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "sqs_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type = object({
    failure_role_arn    = optional(string)
    success_role_arn    = optional(string)
    success_sample_rate = optional(number)
  })
  default = {}

  validation {
    condition = var.sqs_feedback.success_sample_rate == null ? true : (
      var.sqs_feedback.success_sample_rate >= 0 &&
      var.sqs_feedback.success_sample_rate <= 100
    )
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "firehose_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type = object({
    failure_role_arn    = optional(string)
    success_role_arn    = optional(string)
    success_sample_rate = optional(number)
  })
  default = {}

  validation {
    condition = var.firehose_feedback.success_sample_rate == null ? true : (
      var.firehose_feedback.success_sample_rate >= 0 &&
      var.firehose_feedback.success_sample_rate <= 100
    )
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "subscriptions" {
  description = "A map of subscription configurations"
  type = map(object({
    protocol                        = string
    endpoint                        = string
    confirmation_timeout_in_minutes = optional(number, 1)
    endpoint_auto_confirms          = optional(bool, false)
    raw_message_delivery            = optional(bool, false)
    filter_policy                   = optional(string)
    filter_policy_scope             = optional(string)
    delivery_policy                 = optional(string)
    redrive_policy                  = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.subscriptions : contains([
        "application", "email", "email-json", "firehose", "http", "https",
        "lambda", "sms", "sqs"
      ], v.protocol)
    ])
    error_message = "Valid protocols are: application, email, email-json, firehose, http, https, lambda, sms, sqs."
  }
}

variable "lambda_permissions" {
  description = "Map of Lambda function ARNs that should be granted permission to be invoked by this SNS topic"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "create_topic" {
  description = "Whether to create the SNS topic"
  type        = bool
  default     = true
}

variable "create_subscription" {
  description = "Whether to create SNS subscriptions"
  type        = bool
  default     = true
}
