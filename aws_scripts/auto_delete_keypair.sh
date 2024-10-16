#!/bin/bash
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=,
    read REGION_NAME VPC_NAME SECURITY_GROUP_NAME IP_RANGE KEY_NAME SUBNET_PUB SUBNET_PRI REGION_ID GATEWAY_NAME EIP_NAT_NAME NATGW_NAME ROUTE_TABLE_PUBLIC_NAME ROUTE_TABLE_PRIVATE_NAME <<<${line}

#    aws ec2 create-key-pair --region $REGION_ID --key-name $KEY_NAME --query KeyMaterial --output text > $KEY_NAME.pem
    aws ec2 delete-key-pair --region $REGION_ID --key-name $KEY_NAME
done
