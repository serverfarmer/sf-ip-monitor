#!/bin/sh

/opt/farm/scripts/setup/extension.sh sf-cache-utils
/opt/farm/scripts/setup/extension.sh sf-net-utils
/opt/farm/scripts/setup/extension.sh sf-sms-smsapi

current="/etc/local/.config/external.ip"

if [ ! -f $current ]; then
	/opt/farm/ext/net-utils/external/ip.sh >$current
fi

if ! grep -q /opt/farm/ext/ip-monitor/cron/check.sh /etc/crontab; then
	echo "*/5 * * * * root /opt/farm/ext/ip-monitor/cron/check.sh" >>/etc/crontab
fi

if ! grep -q /opt/farm/ext/ip-monitor/cron/report.sh /etc/crontab && [ -f /etc/X11/xinit/xinitrc ]; then
	echo "34 18 * * * root /opt/farm/ext/ip-monitor/cron/report.sh" >>/etc/crontab
fi
