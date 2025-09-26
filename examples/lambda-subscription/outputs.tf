output "topic_arn" {
  description = "ARN of the SNS topic"
  value       = module.lambda_subscription_topic.topic_arn
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.arn
}
