# FIFO SNS Topic Example

This example demonstrates how to create a FIFO (First-In-First-Out) SNS topic with content-based deduplication and a FIFO SQS queue subscription.

## What This Example Creates

- FIFO SNS topic with content-based deduplication
- FIFO SQS queue subscription
- Proper IAM policies for SNS to SQS communication

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_fifo_topic"></a> [fifo\_topic](#module\_fifo\_topic) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.fifo_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.fifo_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enable content-based deduplication | `bool` | `true` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the SNS topic | `string` | `"Order Processing FIFO Topic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "Environment": "development",<br/>  "Example": "fifo-topic",<br/>  "Project": "sns-module-example"<br/>}</pre> | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the SNS FIFO topic (without .fifo suffix) | `string` | `"order-processing-topic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fifo_queue_arn"></a> [fifo\_queue\_arn](#output\_fifo\_queue\_arn) | ARN of the FIFO SQS queue |
| <a name="output_subscriptions"></a> [subscriptions](#output\_subscriptions) | Map of created subscriptions |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN of the created FIFO SNS topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | Name of the created FIFO SNS topic |
<!-- END_TF_DOCS -->
