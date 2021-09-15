#!/bin/bash
echo $1,$2
export AWS_REGION=$2
failed=0
success=0
for value in $(nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}')
do
echo $value
aws shield create-protection  --name "Protection for CloudFront distribution"  --resource-arn arn:aws:ec2:$2:$3:eip-allocation/$( aws ec2 describe-addresses --public-ip $value | jq '.Addresses[0].AllocationId'|cut -d'"' -f 2)
if [ $? -gt 0 ]
then
echo "EIP $value missing"
failed=$((failed+1))
else 
success=$((success+1))
echo "Checked $value"
fi
done
echo success- $success
echo failed - $failed
