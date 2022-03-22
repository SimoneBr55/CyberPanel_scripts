#!/bin/bash
if [[ $1 == "-h" ]]
then
	echo "===================USAGE================="
	echo "Debug mode (verbose):"
	echo "checkRecord --debug"
	echo ""
	echo "If you want to use arguments:"
	echo "checkRecord -a <domain> [--debug]"
	exit 0
fi

if [[ $1 == "-a" ]]
then
	SUBDOMAIN=$2
else
	source /etc/DUC/.set_env_vars
fi

IP_RECORD=$(dig +short $SUBDOMAIN @8.8.8.8)
IP_CURRENT=$(curl -s https://api.ipify.org 2>/dev/null)

if [[ $IP_RECORD == $IP_CURRENT ]] 
then
	if [[ $1 == "--debug" ]] || [[ $3 == "--debug" ]]
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
