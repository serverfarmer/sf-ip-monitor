#!/bin/bash
. /opt/farm/scripts/functions.custom
# check if external IP address changed without announcements
# Tomasz Klim, Sep 2013, Mar 2015, Dec 2015, Jul 2018


phone="`notify_phone`"
email="external-ip@`external_domain`"

file="/var/cache/cacti/external-ip"
current="/etc/local/.config/external.ip"

# not all connections succeed, especially for some providers
/opt/farm/ext/net-utils/external/ip.sh >$file.new
if [ ! -s $file.new ]; then exit; fi

# if current IP differs from previous one, trigger notifications
diff -u $current $file.new >$file.diff
if [ -s $file.diff ]; then
	/opt/farm/ext/sms-smsapi/sms.sh $phone "`hostname` detected external IP change to `cat $file.new`" >>$file.diff
	cat $file.diff |mail -s "External IP change [`hostname`]" $email
	mv -f $file.new $current
fi
