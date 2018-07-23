#!/bin/bash
. /opt/farm/scripts/functions.custom
# check if external IP address changed without announcements
# Tomasz Klim, Sep 2013, Mar 2015, Dec 2015, Jul 2018


file="/var/cache/cacti/external-ip"
current="/etc/local/.config/external.ip"

# not all connections succeed, especially for some providers
/opt/farm/ext/net-utils/external/ip.sh >$file.new
if [ ! -s $file.new ]; then exit; fi

# if current IP differs from previous one, trigger notifications
diff -u $current $file.new >$file.diff
if [ -s $file.diff ]; then

	if [ -s /etc/local/.config/notify.phone ]; then
		phone="`cat /etc/local/.config/notify.phone`"
		/opt/farm/ext/sms-smsapi/sms.sh $phone "`hostname` detected external IP change to `cat $file.new`" >>$file.diff
	fi

	cat $file.diff |mail -s "External IP change [`hostname`]" "external-ip@`external_domain`"
	mv -f $file.new $current
fi
