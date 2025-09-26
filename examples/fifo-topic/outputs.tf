output "topic_arn" {
  description = "ARN of the created FIFO SNS topic"
  value       = module.fifo_topic.topic_arn
}

output "topic_name" {
  description = "Name of the created FIFO SNS topic"
  value       = module.fifo_topic.topic_name
}

output "fifo_queue_arn" {
  description = "ARN of the FIFO SQS queue"
  value       = aws_sqs_queue.fifo_queue.arn
}

output "subscriptions" {
  description = "Map of created subscriptions"
  value       = module.fifo_topic.subscriptions
}
