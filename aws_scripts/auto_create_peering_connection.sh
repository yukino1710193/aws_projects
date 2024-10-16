#!/bin/bash
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=,
    read REGION_NAME VPC_NAME SECURITY_GROUP_NAME IP_RANGE KEY_NAME SUBNET_PUB SUBNET_PRI REGION_ID GATEWAY_NAME EIP_NAT_NAME NATGW_NAME ROUTE_TABLE_PUBLIC_NAME ROUTE_TABLE_PRIVATE_NAME <<<${line}
    PCX_ID=$(aws ec2 create-vpc-peering-connection --vpc-id vpc-12345678 --peer-vpc-id vpc-87654321 --region us-east-1 --peer-region us-west-2 --query "VpcPeeringConnection.VpcPeeringConnectionId" --output text)
done

PCX_ID=$(aws ec2 create-vpc-peering-connection --vpc-id vpc-12345678 --peer-vpc-id vpc-87654321 --region us-east-1 --peer-region us-west-2 --query "VpcPeeringConnection.VpcPeeringConnectionId" --output text)
aws ec2 create-vpc-peering-connection --vpc-id vpc-xxxxxxxx --peer-vpc-id vpc-yyyyyyyy --region <region1> --peer-region <region2>
aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id pcx-xxxxxxxx --region <region2>
aws ec2 create-route --route-table-id rtb-xxxxxxxx --destination-cidr-block <CIDR của VPC peer> --vpc-peering-connection-id pcx-xxxxxxxx --region <region1>
aws ec2 create-route --route-table-id rtb-yyyyyyyy --destination-cidr-block <CIDR của VPC đầu tiên> --vpc-peering-connection-id pcx-xxxxxxxx --region <region2>