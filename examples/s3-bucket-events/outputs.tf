output "topic_arn" {
  description = "The ARN of the SNS topic"
  value       = module.s3_events_sns_topic.topic_arn
}

output "topic_name" {
  description = "The name of the SNS topic"
  value       = module.s3_events_sns_topic.topic_name
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}
