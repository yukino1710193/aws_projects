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
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text --region $REGION_ID)
    GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" --query "SecurityGroups[0].GroupId" --output text --region $REGION_ID)
    SUBNET_PUB_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=SUBNET_PUB" --query "Subnets[0].SubnetId" --output text --region $REGION_ID)
    SUBNET_PRI_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=SUBNET_PRI" --query "Subnets[0].SubnetId" --output text --region $REGION_ID)
    IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=$GATEWAY_NAME" --query "InternetGateways[0].InternetGatewayId" --output text --region $REGION_ID)
    EIP_NAT_ID=$(aws ec2 describe-addresses --filters "Name=tag:Name,Values=$EIP_NAT_NAME" --query "Addresses[0].AllocationId" --output text --region $REGION_ID)
    NATGW_ID=$(aws ec2 describe-nat-gateways --filters "Name=tag:Name,Values=$NATGW_NAME" --query "NatGateways[0].NatGatewayId" --output text --region $REGION_ID)
    ROUTE_TABLE_PUBLIC_ID=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PUBLIC_NAME" --query "RouteTables[0].RouteTableId" --output text --region $REGION_ID)
    ROUTE_TABLE_PRIVATE_ID=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_NAME" --query "RouteTables[0].RouteTableId" --output text --region $REGION_ID)

# Delete
aws ec2 delete-security-group --group-id $GROUP_ID --region $REGION_ID
aws ec2 delete-subnet --subnet-id $SUBNET_PRI_ID --region $REGION_ID
aws ec2 delete-subnet --subnet-id $SUBNET_PUB_ID --region $REGION_ID
aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_PRIVATE_ID --region $REGION_ID
aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_PUBLIC_ID --region $REGION_ID
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION_ID
aws ec2 release-address --allocation-id $EIP_NAT_ID --region $REGION_ID
aws ec2 delete-nat-gateway --nat-gateway-id $NATGW_ID --region $REGION_ID
aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION_ID