import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    logger.info(f"Received SNS event: {json.dumps(event)}")

    for record in event['Records']:
        sns_message = record['Sns']
        message = sns_message['Message']
        subject = sns_message.get('Subject', 'No Subject')

        logger.info(f"Processing message: {subject}")
        logger.info(f"Message body: {message}")

        # Add your message processing logic here

    return {
        'statusCode': 200,
        'body': json.dumps('Messages processed successfully')
    }
