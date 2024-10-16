#!/bin/bash
# FILE=${1}
# IFS=$'\n'

# for line in $(cat ${FILE})
# do
#     echo ${line}
#     IFS=,
#     read REGION_NAME VPC_NAME SECURITY_GROUP_NAME IP_RANGE KEY_NAME SUBNET_PUB SUBNET_PRI REGION_ID GATEWAY_NAME EIP_NAT_NAME NATGW_NAME ROUTE_TABLE_PUBLIC_NAME ROUTE_TABLE_PRIVATE_NAME <<<${line}

#     VPC_ID=$(aws ec2 describe-vpcs --region $REGION_ID --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text)
#     GROUP_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID Name=group-name,Values=testbed_group --region $REGION_ID --query "SecurityGroups[0].GroupId" --output text)
# #    aws ec2 create-security-group --region $REGION_ID --group-name testbed_group --description Hello --vpc-id $VPC_ID
#     aws ec2 delete-security-group --group-id $GROUP_ID --region $REGION_ID
# done

REGION_NAME=$1
VPC_NAME=$2
SECURITY_GROUP_NAME=$3
IP_RANGE=$4
KEY_NAME=$5
SUBNET_PUB=$6
SUBNET_PRI=$7
REGION_ID=$8
GATEWAY_NAME=$9
EIP_NAT_NAME=${10}
NATGW_NAME=${11}
ROUTE_TABLE_PUBLIC_NAME=${12}
ROUTE_TABLE_PRIVATE_NAME=${13}

    VPC_ID=$(aws ec2 describe-vpcs --region $REGION_ID --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text)
    GROUP_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID Name=group-name,Values=testbed_group --region $REGION_ID --query "SecurityGroups[0].GroupId" --output text)
#    aws ec2 create-security-group --region $REGION_ID --group-name testbed_group --description Hello --vpc-id $VPC_ID
    aws ec2 delete-security-group --group-id $GROUP_ID --region $REGION_ID