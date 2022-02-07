#!/bin/bash
if [[ $1 == "-h" ]]
then
	echo "===================USAGE================="
	echo "Arguments:"
	echo "checkRecord --debug"
fi

source /etc/DUC/.set_env_vars

IP_RECORD=$(dig +short $SUBDOMAIN @1.1.1.1)
IP_CURRENT=$(curl ifconfig.co 2>/dev/null)

if [[ $IP_RECORD == $IP_CURRENT ]] 
then
	if [[ $1 == "--debug" ]]
	then
		echo "DEBUG:"
		echo "IP is still the same"
		echo "RECORD = " $IP_RECORD
		echo "CURRENT = " $IP_CURRENT
	fi
	unset IP_RECORD
	unset IP_CURRENT
	exit 0
else
	if [[ $1 == "--debug" ]]
	then
		echo "DEBUG:"
		echo "IP has changed!!!"
		echo "RECORD = " $IP_RECORD
		echo "CURRENT = " $IP_CURRENT
	fi
	python3 /usr/local/lib/ip_maint.py
	unset IP_RECORD
	unset IP_CURRENT
fi
