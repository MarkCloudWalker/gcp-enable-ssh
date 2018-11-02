#!/bin/bash
#gcloud_ssh_enable.sh
# Mark Patterson
# mark@3labs.io
# 11-02-2018
# Script to empower GCP gcloud shell users to be secure via a whitelist and still have the ability to use ssh
# Dynamically creates and updates firewall rules to allow ssh to work from the gcloud shell 
# Also adds in the google ip ranges so the web console based ssh sessions will work as well
# The default firewall rule for ssh allows the entire world to connect
# Removing that default firewall rule breaks ssh sessions through the google cloud console, hence the reason for this script
# 
# Enjoy :)


#Modify the network and other settings as needed to match your use case
#This script assumes that you are running it in the gcloud console from the target project
#
#Define FW Network/VPC name
fw_net="change-me-never-use-default"

#Firewall Rules to allow
fw_rules="tcp:22"

#Start building firewall rule name
#Set FW Rule Prefix
fw_rule_name_prefix="gcshell-ssh"

#Bring in gcloud current logged on username
fw_rule_user=${USER//[^-a-z0-9]/}

#Build rough Firewall Rule Name
fw_rule_name_rough=${fw_rule_name_prefix}"-"${fw_net}"-"${fw_rule_user}

#Build Firewall rule name and filter out characters not allowed in a FW rule name
fw_rule_name=${fw_rule_name_rough//[^-a-z0-9]/}

#Define Source ip to current gloud shell External IP
#src_ip=$DEVSHELL_IP_ADDRESS

#Define Source ips, Google SPF IP Range + gcloud Shell External IP

src_ip=`nslookup -q=TXT _spf.google.com| tr ' ' '\n'|grep include|cut -d : -f2|xargs -i nslookup -q=TXT {}|tr ' ' '\n'|grep ip4|cut -d: -f2|tr '\n' ','`$DEVSHELL_IP_ADDRESS

#Aloha
echo "Welcome to gcloud_ssh_enable v1.2  ...working for you..."

if [[ $(gcloud compute firewall-rules list --format=list --filter name=${fw_rule_name}|wc -c) -ne 0 ]]; then
    echo "Updating FW Rule $fw_rule_name"
    #Update Dynamic Google Cloud Shell FW Rule 
    gcloud compute firewall-rules update $fw_rule_name --source-ranges=$src_ip

else
    echo "Creating FW Rule $fw_rule_name"
    #Create Dynamic Google Cloud Shell FW - Rule Run Once
    gcloud compute firewall-rules create $fw_rule_name --description=Dyn-SSH-FW \
    --direction=INGRESS --priority=1000 --network=$fw_net --action=ALLOW --rules=$fw_rules --source-ranges=$src_ip

fi
