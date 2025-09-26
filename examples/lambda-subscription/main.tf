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

module "lambda" {
  source  = "sourcefuse/arc-lambda-function/aws"
  version = "0.0.1"


  function_name = "sns-lambda-subscription"
  description   = "Lambda for sns-lambda-subscription"
  handler       = "lambda_function.handler"
  runtime       = "python3.9"
  filename      = "${path.module}/lambda/lambda_function.zip"
  timeout       = 30

  lambda_permissions = {
    sns_invoke = {
      action     = "lambda:InvokeFunction"
      principal  = "sns.amazonaws.com"
      source_arn = module.lambda_subscription_topic.topic_arn
    }
  }

  tags = module.tags.tags
}

module "lambda_subscription_topic" {
  source = "../../"

  name         = var.topic_name
  display_name = var.display_name

  subscriptions = {
    lambda_processor = {
      protocol = "lambda"
      endpoint = module.lambda.arn
      filter_policy = jsonencode({
        event_type = var.filter_event_types
      })
    }
  }

  tags = module.tags.tags
}
