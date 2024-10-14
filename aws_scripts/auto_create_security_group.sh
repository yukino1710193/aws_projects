#!/bin/bash
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=,
    read REGION_ID KEY_NAME SUBNET_PUB SUBNET_PRI IP_RANGE VPC_NAME <<<${line}

    VPC_ID=$(aws ec2 describe-vpcs --region $REGION_ID --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text)
#    GROUP_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID Name=group-name,Values=testbed_group --region $REGION_ID --query "SecurityGroups[0].GroupId" --output text)
    aws ec2 create-security-group --region $REGION_ID --group-name testbed_group --description Hello --vpc-id $VPC_ID
#    aws ec2 delete-security-group --group-id $GROUP_ID --region $REGION_ID
done