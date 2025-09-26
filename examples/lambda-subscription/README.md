# Lambda Subscription Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | sourcefuse/arc-lambda-function/aws | 0.0.1 |
| <a name="module_lambda_subscription_topic"></a> [lambda\_subscription\_topic](#module\_lambda\_subscription\_topic) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the SNS topic | `string` | `"Lambda Subscription Topic"` | no |
| <a name="input_filter_event_types"></a> [filter\_event\_types](#input\_filter\_event\_types) | List of event types to filter for | `list(string)` | <pre>[<br/>  "user_signup",<br/>  "user_login",<br/>  "password_reset"<br/>]</pre> | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Lambda function timeout in seconds | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "Environment": "development",<br/>  "Example": "lambda-subscription",<br/>  "Project": "sns-module-example"<br/>}</pre> | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the SNS topic | `string` | `"lambda-subscription-topic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | ARN of the Lambda function |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN of the SNS topic |
<!-- END_TF_DOCS -->
