#!/bin/bash
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=,
    read REGION_ID KEY_NAME SUBNET_PUB SUBNET_PRI IP_RANGE VPC_NAME <<<${line}

#    aws ec2 create-key-pair --region $REGION_ID --key-name $KEY_NAME --query KeyMaterial --output text > $KEY_NAME.pem
    aws ec2 delete-key-pair --region $REGION_ID --key-name $KEY_NAME
done
