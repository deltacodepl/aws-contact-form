from email.quoprimime import body_check
import imp
import os
import json
import boto3
from botocore.exceptions import ClientError 


SUCCESS = 200
CLIENT_ERROR = 400
SERVER_ERROR = 500
EMAIL_SOURCE = os.environ['EMAIL_SOURCE']
EMAIL_RECIPIENT = os.environ['EMAIL_RECIPIENT']
REGION = os.environ['REGION']


def response(statusCode: str, errors : dict = None):

    body = {
        'msg': 'message sent' if statusCode == SUCCESS else 'error'
    }

    return {
        'statusCode': statusCode,
        'body': json.dumps(body),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
        },
    }


# lambda handler event, context
def sendEmail(event, context):
 
    if event:
        body = json.loads(event['body'])
        data = {
            "senderName": body.get('senderName'),
            "email": body.get('email'),
            "message": body.get('message')
        }

        try:
            ses_client = boto3.client('ses', region_name=REGION)

            ses_client.send_email(
                Destination={
                    "ToAddresses": [
                        EMAIL_RECIPIENT,
                    ],
                },
                ReplyToAddresses=[f"{data['senderName']} <{data['email']}>"],
                Message={
                    "Body": {
                        "Html": {
                            "Charset": 'UTF-8',
                            "Data": data['message'],
                        }
                    },
                    "Subject": {
                        "Charset": 'UTF-8',
                        "Data":  " ".join(("Wiadomość S24 from ", body.get('senderName'), data['email'])),
                    },
                },
                Source=EMAIL_SOURCE,
            )

        except (ClientError, Exception) as e:
            print('SES error', e)
            return response(SERVER_ERROR)

        return response(SUCCESS)

    else: return response(SERVER_ERROR)
