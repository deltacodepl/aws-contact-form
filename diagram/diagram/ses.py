from diagrams import Diagram
from diagrams.aws.database import Dynamodb
from diagrams.aws.storage import S3
from diagrams.aws.engagement import SES
from diagrams.aws.mobile import APIGateway
from diagrams.generic.device import Tablet
from diagrams.aws.compute import Lambda, LambdaFunction

attributes = {"pad": "1.0", "fontsize": "25"}
with Diagram(
    "", show=True, direction="LR", outformat="png", graph_attr=attributes
):
    # tablet = Tablet("HTML Contact Form")
    api = APIGateway("Http API GW")
    send_email = LambdaFunction("Lambda function")
    email_service = SES("SES Email Service")

    # db = Dynamodb("primary DB")

    # >> 
    
    S3("s3") >> api >> send_email >> email_service

  
