#!/bin/bash
    REGION_ID1=$1
    VPC_NAME1=$2
    ROUTE_TABLE_PUBLIC_NAME1=$3
    OUTE_TABLE_PRIVATE_NAME1=$4
    IP_RANGE1=$5

    REGION_ID2=$6
    VPC_NAME2=$7
    ROUTE_TABLE_PUBLIC_NAME2=$8
    ROUTE_TABLE_PRIVATE_NAME2=$9
    IP_RANGE2=$10
    # SET PARAM
    VPC_ID1=$(aws ec2 describe-vpcs --region $REGION_ID1 --filters "Name=tag:Name,Values=$VPC_NAME1" --query "Vpcs[0].VpcId" --output text)
    VPC_ID2=$(aws ec2 describe-vpcs --region $REGION_ID2 --filters "Name=tag:Name,Values=$VPC_NAME2" --query "Vpcs[0].VpcId" --output text)
    ROUTE_TABLE_PUBLIC_ID1=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PUBLIC_NAME1" "Name=vpc-id,Values=$VPC_ID1" --region $REGION_ID1 --query 'RouteTables[*].RouteTableId' --output text)
    ROUTE_TABLE_PRIVATE_ID1=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_NAME1" "Name=vpc-id,Values=$VPC_ID1" --region $REGION_ID1 --query 'RouteTables[*].RouteTableId' --output text)
    ROUTE_TABLE_PUBLIC_ID2=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PUBLIC_NAME2" "Name=vpc-id,Values=$VPC_ID2" --region $REGION_ID2 --query 'RouteTables[*].RouteTableId' --output text)
    ROUTE_TABLE_PRIVATE_ID2=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_NAME2" "Name=vpc-id,Values=$VPC_ID2" --region $REGION_ID2 --query 'RouteTables[*].RouteTableId' --output text)
    # Create a peering connection from region_1 -> region_2 
    PCX_ID=$(aws ec2 create-vpc-peering-connection --vpc-id $VPC_ID1 --peer-vpc-id $VPC_ID2 --region $REGION_ID1 --peer-region $REGION_ID2 --query "VpcPeeringConnection.VpcPeeringConnectionId" --output text)
    # Accept connection
    aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id $PCX_ID --region $REGION_ID2
    # Create Route rule from Region 1 to 2
# pub
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PUBLIC_ID1 --destination-cidr-block $IP_RANGE2 --vpc-peering-connection-id $PCX_ID --region $REGION_ID1
# pri
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PRIVATE_ID1 --destination-cidr-block $IP_RANGE2 --vpc-peering-connection-id $PCX_ID --region $REGION_ID1
    # Create Route rule from Region 2 to 1
# pub
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PUBLIC_ID2 --destination-cidr-block $IP_RANGE1 --vpc-peering-connection-id $PCX_ID --region $REGION_ID2
# pri
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PRIVATE_ID2 --destination-cidr-block $IP_RANGE1 --vpc-peering-connection-id $PCX_ID --region $REGION_ID2