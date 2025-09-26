terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.6"

  environment = terraform.workspace
  project     = "terraform-aws-arc-sns"

  extra_tags = {
    Example = "True"
  }
}

# FIFO SQS Queue for subscription
resource "aws_sqs_queue" "fifo_queue" {
  name                        = "${var.topic_name}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

  tags = module.tags.tags
}

# SQS Queue Policy to allow SNS to send messages
data "aws_caller_identity" "current" {}

resource "aws_sqs_queue_policy" "fifo_queue" {
  queue_url = aws_sqs_queue.fifo_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.fifo_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${var.topic_name}.fifo"
          }
        }
      }
    ]
  })
}

module "fifo_topic" {
  source = "../../"

  name                        = var.topic_name
  display_name                = var.display_name
  fifo_topic                  = true
  content_based_deduplication = var.content_based_deduplication

  subscriptions = {
    fifo_sqs = {
      protocol = "sqs"
      endpoint = aws_sqs_queue.fifo_queue.arn
    }
  }

  tags = module.tags.tags
}
