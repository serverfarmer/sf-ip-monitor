#!/bin/bash
. /opt/farm/scripts/functions.custom
# send periodic (eg. daily) detailed reports about local and external network
# state; useful on servers with dynamic local and/or remote IP address
# Tomasz Klim, 2009-2011, Dec 2015


provider="wppl"


if [ "$1" != "" ]; then
	rcpt="$1"
else
	rcpt="network-reports@`external_domain`"
fi

if [ "$2" != "" ]; then
	template="$2"
else
	template="Network state on %%host%%"
fi

host=`hostname`
subject=`echo "$template" |sed s/%%host%%/$host/g`

(

echo -n "External IP: "
/opt/farm/ext/ip-monitor/providers/$provider.sh
echo
echo
/sbin/ifconfig -a |grep -v 127.0.0 |grep -B1 "inet addr"
echo
echo
/sbin/route -ne
echo
echo
/usr/sbin/arp -na

) |mail -s "$subject" $rcpt
