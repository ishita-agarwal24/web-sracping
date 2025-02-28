#!/bin/bash

# AWS Configuration
AMI_ID="ami-01e3c4a339a264cc9"  # Change if needed
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-key-pair"
KEY_FILE="ishita-agarwal.pem"  # Updated key file
SECURITY_GROUP="default"
BUCKET_NAME="ishita-agarwal"

# 1️⃣ Launch EC2 Instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP \
    --query "Instances[0].InstanceId" \
    --output text)

echo "✅ Launched EC2 Instance: $INSTANCE_ID"

# 2️⃣ Wait for EC2 to be ready
echo "⏳ Waiting for EC2 to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# 3️⃣ Get EC2 Public IP
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "🌐 EC2 Public IP: $PUBLIC_IP"

# 4️⃣ Copy scraper script to EC2
scp -i $KEY_FILE -o StrictHostKeyChecking=no scripts/scraper.py ec2-user@$PUBLIC_IP:/home/ec2-user/scraper.py

# 5️⃣ Run scraper on EC2
ssh -i $KEY_FILE -o StrictHostKeyChecking=no ec2-user@$PUBLIC_IP << EOF
    sudo yum update -y
    sudo yum install python3 -y
    pip3 install requests beautifulsoup4 boto3
    python3 /home/ec2-user/scraper.py
EOF

# 6️⃣ Terminate EC2
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
echo "💀 EC2 Instance Terminated: $INSTANCE_ID"

echo "🚀 Deployment Completed!"
