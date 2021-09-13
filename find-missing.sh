#!/bin/bash

echo $1,$2
for value in $(nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}')
do
echo $value
resp=$(aws ec2 describe-addresses --public-ips $value --region $2)
if [ $? -gt 0 ]
then
echo "EIP $value missing"
else
echo "Checked $value"
fi
done
