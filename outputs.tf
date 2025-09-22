output "topic_arn" {
  description = "The ARN of the SNS topic"
  value       = var.create_topic ? aws_sns_topic.this[0].arn : null
}

output "topic_id" {
  description = "The ID of the SNS topic"
  value       = var.create_topic ? aws_sns_topic.this[0].id : null
}

output "topic_name" {
  description = "The name of the SNS topic"
  value       = var.create_topic ? aws_sns_topic.this[0].name : null
}

output "topic_display_name" {
  description = "The display name of the SNS topic"
  value       = var.create_topic ? aws_sns_topic.this[0].display_name : null
}

output "topic_owner" {
  description = "The AWS Account ID of the SNS topic owner"
  value       = var.create_topic ? aws_sns_topic.this[0].owner : null
}

output "subscriptions" {
  description = "Map of subscriptions created and their attributes"
  value = {
    for k, v in aws_sns_topic_subscription.this : k => {
      arn                            = v.arn
      confirmation_was_authenticated = v.confirmation_was_authenticated
      owner_id                       = v.owner_id
      pending_confirmation           = v.pending_confirmation
    }
  }
}
