#!/usr/bin/env bash

set -e

QUEUE_NAME="satellite-data-ingester-dev_rawdata_noaa_goes16"
ATTRIBUTE_FILE="dev-sqs-attributes-replaced.json"

#-- set defaults
if [ -z ${AWS_ACCESS_KEY_ID} ]
then
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE # These don't make sense yet ...
fi
if [ -z ${AWS_SECRET_ACCESS_KEY} ]
then
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY  # These don't make sense yet ...
fi
if [ -z ${AWS_DEFAULT_REGION} ]
then
    export AWS_DEFAULT_REGION=eu-west-1
fi


echo "creating queue..."
cat dev-sqs-attributes.json \
    | sed -e "s/_QUEUE_NAME_/${QUEUE_NAME}/g" \
    | sed -e "s/_AWS_DEFAULT_REGION_/${AWS_DEFAULT_REGION}/g" \
    > ${ATTRIBUTE_FILE}
aws sqs create-queue \
    --queue-name ${QUEUE_NAME} \
    --attributes  file://${ATTRIBUTE_FILE}

echo "creating subscription..."
#    --topic-arn "arn:aws:sns:us-east-1:123901341784:NewGOES16Object" \
#    --region us-east-1
aws sns subscribe \
    --topic-arn "arn:aws:sns:eu-west-1:234294323561:satellite-data-ingester-dev_archive_rawdata_noaa_goes16" \
    --protocol sqs \
    --notification-endpoint arn:aws:sqs:${AWS_DEFAULT_REGION}:234294323561:${QUEUE_NAME} \
    --region ${AWS_DEFAULT_REGION}

rm -f ${ATTRIBUTE_FILE} || True
echo "...finished!"

