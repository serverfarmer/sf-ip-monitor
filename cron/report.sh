#!/bin/bash
. /opt/farm/scripts/functions.custom
# send periodic (eg. daily) detailed reports about local and external network
# state; useful on servers with dynamic local and/or remote IP address
# Tomasz Klim, 2009-2011, Dec 2015, Jul 2018


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
/opt/farm/ext/net-utils/external/ip.sh
echo
echo
if [ -x /sbin/ifconfig ]; then
	/sbin/ifconfig -a |grep -v 127.0.0 |grep -B1 "inet addr"
else
	/sbin/ip addr |grep -v 127.0.0 |grep -B2 "inet "
fi
echo
echo
/sbin/route -ne
echo
echo
/usr/sbin/arp -na
echo
echo
/sbin/iptables -nvL
echo
echo
netstat -nap |grep -v ^unix
echo
echo
if [ -x /usr/bin/smbstatus ]; then
	/usr/bin/smbstatus
fi

) |mail -s "$subject" $rcpt
