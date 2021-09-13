#!/bin/bash

echo $1,$2
for value in $(nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}')
do
echo $value
aws ec2 allocate-address --domain vpc --address $value --region $2
done
