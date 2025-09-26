output "topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.basic_sns_topic.topic_arn
}

output "topic_name" {
  description = "Name of the created SNS topic"
  value       = module.basic_sns_topic.topic_name
}
