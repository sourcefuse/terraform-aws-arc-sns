
locals {
  # Handle FIFO topic naming
  name       = try(trimsuffix(var.name, ".fifo"), "")
  topic_name = var.fifo_topic ? "${local.name}.fifo" : local.name

  # Lambda subscriptions for permission creation
  lambda_subscriptions = {
    for k, v in var.subscriptions : k => v
    if v.protocol == "lambda" && var.create_subscription
  }

  # Common tags
  common_tags = merge(
    var.tags,
    {
      Name = local.topic_name
    }
  )
}

# SNS Topic
resource "aws_sns_topic" "this" {
  count = var.create_topic ? 1 : 0

  name        = var.use_name_prefix ? null : local.topic_name
  name_prefix = var.use_name_prefix ? "${local.name}-" : null

  display_name                = var.display_name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  fifo_throughput_scope       = var.fifo_throughput_scope
  archive_policy              = var.archive_policy
  kms_master_key_id           = var.kms_master_key_id
  delivery_policy             = var.delivery_policy
  policy                      = var.policy
  signature_version           = var.fifo_topic ? null : var.signature_version
  tracing_config              = var.tracing_config

  # Application feedback
  application_failure_feedback_role_arn    = try(var.application_feedback.failure_role_arn, null)
  application_success_feedback_role_arn    = try(var.application_feedback.success_role_arn, null)
  application_success_feedback_sample_rate = try(var.application_feedback.success_sample_rate, null)

  # HTTP feedback
  http_failure_feedback_role_arn    = try(var.http_feedback.failure_role_arn, null)
  http_success_feedback_role_arn    = try(var.http_feedback.success_role_arn, null)
  http_success_feedback_sample_rate = try(var.http_feedback.success_sample_rate, null)

  # Lambda feedback
  lambda_failure_feedback_role_arn    = try(var.lambda_feedback.failure_role_arn, null)
  lambda_success_feedback_role_arn    = try(var.lambda_feedback.success_role_arn, null)
  lambda_success_feedback_sample_rate = try(var.lambda_feedback.success_sample_rate, null)

  # SQS feedback
  sqs_failure_feedback_role_arn    = try(var.sqs_feedback.failure_role_arn, null)
  sqs_success_feedback_role_arn    = try(var.sqs_feedback.success_role_arn, null)
  sqs_success_feedback_sample_rate = try(var.sqs_feedback.success_sample_rate, null)

  # Firehose feedback
  firehose_failure_feedback_role_arn    = try(var.firehose_feedback.failure_role_arn, null)
  firehose_success_feedback_role_arn    = try(var.firehose_feedback.success_role_arn, null)
  firehose_success_feedback_sample_rate = try(var.firehose_feedback.success_sample_rate, null)

  tags = local.common_tags
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "this" {
  for_each = var.create_topic && var.create_subscription ? var.subscriptions : {}

  topic_arn                       = aws_sns_topic.this[0].arn
  protocol                        = each.value.protocol
  endpoint                        = each.value.endpoint
  confirmation_timeout_in_minutes = try(each.value.confirmation_timeout_in_minutes, null)
  endpoint_auto_confirms          = try(each.value.endpoint_auto_confirms, null)
  raw_message_delivery            = try(each.value.raw_message_delivery, null)
  filter_policy                   = try(each.value.filter_policy, null)
  filter_policy_scope             = each.value.filter_policy != null ? try(each.value.filter_policy_scope, null) : null
  delivery_policy                 = try(each.value.delivery_policy, null)
  redrive_policy                  = try(each.value.redrive_policy, null)
}

# Lambda permissions for SNS to invoke Lambda functions
resource "aws_lambda_permission" "sns_invoke" {
  for_each = var.create_topic ? local.lambda_subscriptions : {}

  statement_id  = "AllowExecutionFromSNS-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.endpoint
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this[0].arn
}

# Additional Lambda permissions for external functions
resource "aws_lambda_permission" "external_lambda" {
  for_each = var.create_topic ? var.lambda_permissions : {}

  statement_id  = "AllowExecutionFromSNS-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this[0].arn
}
