#/bin/bash
## USAGE ## Add nice printout
# You have to set a .set_env_vars (or...) to source here #
# SimoneBr55 #

source .set_env_vars
# source /etc/updateRecordVars # Is it better? Nicer management?

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

## Suggestions: you can add the possibility to pipe the sudo password directly, to make it really automatic... However, the uttermost care must be used when dealing with passwords in scripts... ##
