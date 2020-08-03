# model team
# auth: andrej

# accounts
bash aws-auth

TOPIC=simulated-satellite-data-ecmwf
QUEUE_NAME_DEV=satellite-data-ingestor-${TOPIC}

ATTRIBUTE_FILE_DEV=attributes-${TOPIC}.json

# from env... change
ACCOUNT=669594303610

if [ -z ${AWS_DEFAULT_REGION} ]
then
    export AWS_DEFAULT_REGION=eu-west-1
fi

# s3 bucket events sceduled to
# arn:aws:sns:eu-west-1:669594303610:dev-simulated-satellite-data-ecmwf

# sns topic
aws sns create-topic --name dev-${TOPIC}

TOPIC_ARN=arn:aws:sns:eu-west-1:${ACCOUNT}:dev-${TOPIC}

aws sns get-topic-attributes --topic-arn ${TOPIC_ARN}


# sqs queue and subscription should be moved to cloudformation...
aws sqs create-queue \
    --queue-name ${QUEUE_NAME_DEV} \
    --attributes  file://${ATTRIBUTE_FILE_DEV}

cat ${ATTRIBUTE_FILE_DEV}

aws sns subscribe \
    --topic-arn ${TOPIC_ARN} \
    --protocol sqs \
    --notification-endpoint arn:aws:sqs:${AWS_DEFAULT_REGION}:${ACCOUNT}:${QUEUE_NAME_DEV} \
    --region ${AWS_DEFAULT_REGION}   

#aws sqs list-queues
aws sqs list-queues --queue-name-prefix ${QUEUE_NAME_DEV}
