#!/bin/bash
. /opt/farm/scripts/functions.custom
# check if external IP address changed without announcements
# Tomasz Klim, Sep 2013, Mar 2015, Dec 2015


phone="`notify_phone`"
email="external-ip@`external_domain`"
provider="wppl"

OLDIP="$1"
FILE="/var/cache/cacti/external-ip"

# on my physical servers, /var/cache/cacti directory is mounted as tmpfs,
# so its contents are lost after each reboot and need to be rebuilt
if [ ! -s $FILE.current ]; then
	echo $OLDIP >$FILE.current
fi

# not all connections succeed, especially for some providers
/opt/sf-ip-monitor/providers/$provider.sh >$FILE.new
if [ ! -s $FILE.new ]; then exit; fi

# if current IP differs from previous one, trigger notifications
diff -u $FILE.current $FILE.new >$FILE.diff
if [ -s $FILE.diff ]; then
	/opt/sf-sms-smsapi/sms.sh $phone "`hostname` detected external IP change to `cat $FILE.new`" >>$FILE.diff
	cat $FILE.diff |mail -s "External IP change [`hostname`]" $email
	mv -f $FILE.new $FILE.current
fi
