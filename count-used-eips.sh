#!/bin/bash
echo $(date -u)
echo $1,$2
assigned=0
unassigned=0
error=0
for value in $(nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}')
do
#echo $value
resp=$(aws ec2 describe-addresses --public-ip $value --region $2| jq '.Addresses[0].AssociationId'|cut -d'"' -f 2)
if [ $? -gt 0 ]
then
#echo "EIP $value missing"
$error++
elif [ $resp =  null ]
then
#echo "No association"
((unassigned++))
else 
#echo $resp
((assigned++))
#echo "Checked $value"
fi
done
echo $(date -u)
echo "error - $error , assigned - $assigned , unassigned - $unassigned"
