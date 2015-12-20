#!/bin/bash
. /opt/farm/scripts/init


provider="wppl"


bash /opt/farm/scripts/setup/role.sh sf-sms-smsapi

IP=`/opt/sf-ip-monitor/providers/$provider.sh`

if ! grep -q /opt/sf-ip-monitor/cron/check.sh /etc/crontab && [ "$IP" != "" ]; then
	sed -i -e "/check-external-ip.sh/d" /etc/crontab
	echo "*/5 * * * * root /opt/sf-ip-monitor/cron/check.sh $IP" >>/etc/crontab
fi
