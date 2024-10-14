#!/bin/bash

get_vpc_id(){
    REGION=$1
    VPC_name=$2
    VPC_ID=$(aws ec2 describe-vpcs --region $REGION --filters Name=tag:Name,Values=$VPC_name --query Vpcs[0].VpcId --output text)
    echo $VPC_ID 
}

# #DEMO
# Cách lấy vpc_id và kiểm tra
#
# VPC_ID=$(get_vpc_id REGION your-vpc-name)
# echo VPC ID: $VPC_ID

ec2 create-security-group --group-name $GROUP_NAME --description yukino-san powerful --vpc-id <VPC_ID>
