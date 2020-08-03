# DataServicesDATAS-9087
# auth: andrej

bash aws-auth

# subscribe to s3 bucket sns topic...
BUCKET="svc.mg.model-data-processing.data.s3.mg"
ACCOUNT=234294323561

aws s3api get-bucket-notification-configuration --bucket ${BUCKET}

# sns topic created via terminal
#TOPIC_ARN="arn:aws:sns:eu-west-1:234294323561:dev-simulated-satellite-data"

# topic created by admin
TOPIC_ARN="arn:aws:sns:eu-west-1:${ACCOUNT}:model-data-processing_data_s3_mg_raw-ecmwf_sns"

# create
# queue sqs
QUEUE_NAME="satellite-data-ingester-data_s3_mg_raw-ecmwf_sns-dev"
#ATTRIBUTE_FILE="dev-sqs-attributes-replaced.json"

ATTRIBUTE_FILE="dev-sqs-subscription-ecmwf-attributes.json"

if [ -z ${AWS_DEFAULT_REGION} ]
then
    export AWS_DEFAULT_REGION='eu-west-1'
fi

cat ${ATTRIBUTE_FILE}

aws sqs create-queue \
    --queue-name ${QUEUE_NAME} \
    --attributes  file://${ATTRIBUTE_FILE}

# subscribe to current topic.
aws sns subscribe \
    --topic-arn ${TOPIC_ARN} \
    --protocol sqs \
    --notification-endpoint arn:aws:sqs:${AWS_DEFAULT_REGION}:${ACCOUNT}:${QUEUE_NAME} \
    --region ${AWS_DEFAULT_REGION}

