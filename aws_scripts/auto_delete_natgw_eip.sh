#!/bin/bash

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

# Querry id
    EIP_NAT_ID=$(aws ec2 describe-addresses --filters "Name=tag:Name,Values=$EIP_NAT_NAME" --query "Addresses[0].AllocationId" --output text --region $REGION_ID)
    NATGW_ID=$(aws ec2 describe-nat-gateways --filter "Name=tag:Name,Values=NAT_GW_Hongkong" --region $REGION_ID --query 'NatGateways[*].NatGatewayId' --output text)
    ROUTE_TABLE_PRIVATE_ID=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_NAME" --query "RouteTables[0].RouteTableId" --output text --region $REGION_ID)

    # echo $EIP_NAT_ID
    # echo
    # echo $NATGW_ID
    # echo
    # echo $ROUTE_TABLE_PRIVATE_ID
# Delete
aws ec2 delete-route --route-table-id $ROUTE_TABLE_PRIVATE_ID --destination-cidr-block 0.0.0.0/0 --region $REGION_ID
aws ec2 release-address --allocation-id $EIP_NAT_ID --region $REGION_ID
aws ec2 delete-nat-gateway --nat-gateway-id $NATGW_ID --region $REGION_ID