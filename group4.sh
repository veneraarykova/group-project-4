#!/bin/bash

region=us-east-2

az1=us-east-2a
az2=us-east-2b
az3=us-east-2c

ami_id=ami-01103fb68b3569475

key_name=my-laptop-key


# VPC named "vpc-group-4" with CIDR block 10.0.0.0/16
vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specification "ResourceType=vpc,Tags=[{Key=Name,Value=vpc-group-4}]" --query Vpc.VpcId --output text)


# Security group named "sg-group-4"
sg_id=$(aws ec2 create-security-group --group-name Securitygroup4 --description "Demo Security Group" --vpc-id $vpc_id --query GroupId --output text)




#Open inbound ports 22, 80, 443 for everything in security group "sg-group-4"
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $region
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $region
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $region



# Create 3 public subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in each availability zones respectively (us-east-2a, us-east-2b, us-east-2c)
subnet1_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --availability-zone $az1 --query Subnet.SubnetId --output text --region $region)
subnet2_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 --availability-zone $az2 --query Subnet.SubnetId --output text --region $region)
subnet3_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.3.0/24 --availability-zone $az3 --query Subnet.SubnetId --output text --region $region)



#Create Internet Gateway
igw_id=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)

#Attach Internet Gateway to VPC "vpc-group-4"
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id


# Launch EC2 Instance
aws ec2 run-instances --image-id $ami_id --subnet-id $subnet1_id --security-group-ids $sg_id --instance-type t2.micro --key-name $key_name --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-group-4}]" --region $region
# Optionally, you need to replace <AMI-ID>, <instance-type>, and <key-name> with appropriate values for your u
