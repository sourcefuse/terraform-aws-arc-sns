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
# Create S3 bucket
module "s3" {
  source  = "sourcefuse/arc-s3/aws"
  version = "0.0.4"

  name = var.bucket_name
  acl  = var.acl
  tags = module.tags.tags
}
# SNS topic for S3 events
module "s3_events_sns_topic" {
  source = "../../"

  name         = var.topic_name
  display_name = var.display_name

  tags = module.tags.tags
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3.bucket_id

  topic {
    topic_arn = module.s3_events_sns_topic.topic_arn
    events    = var.s3_events
  }

  depends_on = [aws_sns_topic_policy.s3_policy]
}

# SNS topic policy to allow S3 to publish
resource "aws_sns_topic_policy" "s3_policy" {
  arn = module.s3_events_sns_topic.topic_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = module.s3_events_sns_topic.topic_arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnEquals = {
            "aws:SourceArn" = module.s3.bucket_arn
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
