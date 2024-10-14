#!/bin/bash
FILE=${1}
IFS=$'\n'

for line in $(cat ${FILE})
do
    echo ${line}
    IFS=,
    read REGION_ID KEY_NAME SUBNET_PUB SUBNET_PRI IP_RANGE VPC_NAME <<<${line}
    ## Create VPC get VPC_ID -> and tag VPC_NAME
    VPC_ID=$(aws ec2 create-vpc --region $REGION_ID --cidr-block $IP_RANGE --query "Vpc.VpcId" --output text) && aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION_ID
    ## Create subnet
    #PUBLIC
    SUBNET_PUB_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PUB --region $REGION_ID --query "Subnet.SubnetId" --output text) && aws ec2 create-tags --resources $SUBNET_PUB_ID --tags Key=Name,Value=SUBNET_PUB --region $REGION_ID

    #PRIVATE
    SUBNET_PRI_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PRI --region $REGION_ID --query "Subnet.SubnetId" --output text) && aws ec2 create-tags --resources $SUBNET_PRI_ID --tags Key=Name,Value=SUBNET_PRI --region $REGION_ID

    ## Create an Internet Gateway
    IGW_ID=$(aws ec2 create-internet-gateway --region $REGION_ID --query "InternetGateway.InternetGatewayId" --output text) && aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$GATEWAY_NAME --region $REGION
    # Attach IGW to VPC
    aws ec2 attach-internet-gateway --region $REGION_ID --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
    ## Create a custom route table
    ROUTE_TABLE_PUBLIC_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION_ID --query "RouteTable.RouteTableId" --output text) && aws ec2 create-tags --resources $ROUTE_TABLE_PUBLIC_ID --tags Key=Name,Value=$ROUTE_TABLE_PUBLIC_NAME --region $REGION_ID
    ROUTE_TABLE_PRIVATE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION_ID --query "RouteTable.RouteTableId" --output text) && aws ec2 create-tags --resources $ROUTE_TABLE_PRIVATE_ID --tags Key=Name,Value=$ROUTE_TABLE_PRIVATE_NAME --region $REGION_ID
    
    # Config route-tables
# Public
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PUBLIC_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
## Private
    aws ec2 create-route --route-table-id $ROUTE_TABLE_PRIVATE_NAME --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NATGW_ID
    
    # Associate subnet with custom route table to make public
    aws ec2 associate-route-table  --subnet-id $SUBNET_PUB_ID --route-table-id $ROUTE_TABLE_ID

done
## Associate subnet with custom route table to make public
## Update subnet-id and route-table-id in the command below:
aws ec2 associate-route-table  --subnet-id subnet-00075b1fb13da041d --route-table-id rtb-073ec521b6d5ceff7

## Configure subnet to issue a public IP to EC2 instances
## Update subnet-id in the command below:

aws ec2 modify-subnet-attribute --subnet-id subnet-00075b1fb13da041d --map-public-ip-on-launch


##### LAUNCH INSTANCE INTO SUBNET FOR TESTING #####

## Create a key pair and output to MyKeyPair.pem
## Modify output path accordingly

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ./MyKeyPair.pem

## Linux / Mac only - modify permissions

chmod 400 MyKeyPair.pem

## Create security group with rule to allow SSH

aws ec2 create-security-group --group-name SSHAccess --description "Security group for SSH access" --vpc-id vpc-08c24bb183d741db9

## Copy security group ID from output
## Update group-id in the command below:

aws ec2 authorize-security-group-ingress --group-id sg-01f034bccc4510b66 --protocol tcp --port 22 --cidr 0.0.0.0/0

## Launch instance in public subnet using security group and key pair created previously:
## Obtain the AMI ID from the console, update the security-group-ids and subnet-ids

aws ec2 run-instances --image-id ami-06ce513624b435a22 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-01f034bccc4510b66 --subnet-id subnet-00075b1fb13da041d

## Copy instance ID from output and use in the command below
## Check instance is in running state:

aws ec2 describe-instances --instance-id i-0c7371bbf7888bcdb

## Note the public IP address
## Connect to instance using key pair and public IP

ssh -i MyKeyPair.pem ec2-user@54.253.97.225



##### CLEAN UP #####

## Run commands in the following order replacing all values as necessary

# aws ec2 terminate-instances --instance-ids i-0c7371bbf7888bcdb
# aws ec2 delete-security-group --group-id sg-01f034bccc4510b66
# aws ec2 delete-subnet --subnet-id subnet-02a37f7b7ee80cc01
# aws ec2 delete-subnet --subnet-id subnet-00075b1fb13da041d
# aws ec2 delete-route-table --route-table-id rtb-073ec521b6d5ceff7
# aws ec2 detach-internet-gateway --internet-gateway-id igw-0aa19bd4246f502d8 --vpc-id vpc-08c24bb183d741db9
# aws ec2 delete-internet-gateway --internet-gateway-id igw-0aa19bd4246f502d8
# aws ec2 delete-vpc --vpc-id vpc-08c24bb183d741db9
