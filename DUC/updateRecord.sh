#/bin/bash

source .set_env_vars

ssh -p $SSH_PORT -t -i $LOCATION_RSA admin@$IP_ADDRESS "sudo cyberpanel listDNSPretty --domainName $DOMAIN" |& tee /tmp/DNSRecords.lis
OLD_IP=$(cat /tmp/DNSRecords.lis | grep \ $SUBDOMAIN | grep \ A\ | awk '{print $8}')

[[ $NEW_IP == $OLD_IP ]]
if [[ $? -eq 0 ]]
    then
        echo "The IP has not changed"
    else
        cat /tmp/DNSRecords.lis | grep \ $SUBDOMAIN | grep \ A\ | awk '{print $2}' |& tee /tmp/recordId
        recordid=$(cat /tmp/recordId)
        ssh -p $SSH_PORT -t -i $LOCATION_RSA admin@$IP_ADDRESS "sudo cyberpanel deleteDNSRecord --recordID $recordid"
        ssh -p $SSH_PORT -t -i $LOCATION_RSA admin@$IP_ADDRESS "sudo cyberpanel createDNSRecord --domainName $DOMAIN --name $SUBDOMAIN --recordType A --value $NEW_IP --priority 0 --ttl 60"
fi
