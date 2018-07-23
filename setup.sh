#!/bin/bash

/opt/farm/scripts/setup/extension.sh sf-cache-utils
/opt/farm/scripts/setup/extension.sh sf-net-utils

phone="/etc/local/.config/notify.phone"
current="/etc/local/.config/external.ip"

if [ ! -f $current ]; then
	/opt/farm/ext/net-utils/external/ip.sh >$current
fi

if [ ! -f $phone ]; then
	if [ "$PHONE_NUMBER" = "" ]; then
		read -p "phone number for admin notifications (using smsapi.pl) - 9 digits, or empty to disable notifications: " PHONE_NUMBER
	fi

	if [ "$PHONE_NUMBER" != "" ]; then
		if [ ${#PHONE_NUMBER} != 9 ]; then
			echo "error: invalid phone number length, aborting"
			exit 1
		elif ! [[ $PHONE_NUMBER =~ ^[0-9]+$ ]]; then
			echo "error: phone number contains invalid characters, aborting"
			exit 1
		fi
	fi

	echo -n "$PHONE_NUMBER" >$phone
fi

if [ -s $phone ]; then
	/opt/farm/scripts/setup/extension.sh sf-sms-smsapi
fi

if ! grep -q /opt/farm/ext/ip-monitor/cron/check.sh /etc/crontab; then
	echo "*/5 * * * * root /opt/farm/ext/ip-monitor/cron/check.sh" >>/etc/crontab
fi

if ! grep -q /opt/farm/ext/ip-monitor/cron/report.sh /etc/crontab && [ -f /etc/X11/xinit/xinitrc ]; then
	echo "34 18 * * * root /opt/farm/ext/ip-monitor/cron/report.sh" >>/etc/crontab
fi
