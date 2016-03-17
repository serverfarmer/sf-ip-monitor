#!/bin/sh

provider="wppl"


/opt/farm/scripts/setup/role.sh sf-sms-smsapi

IP=`/opt/farm/ext/ip-monitor/providers/$provider.sh`

if ! grep -q /opt/farm/ext/ip-monitor/cron/check.sh /etc/crontab && [ "$IP" != "" ]; then
	sed -i -e "/check-external-ip.sh/d" /etc/crontab
	echo "*/5 * * * * root /opt/farm/ext/ip-monitor/cron/check.sh $IP" >>/etc/crontab
fi

if ! grep -q /opt/farm/ext/ip-monitor/cron/report.sh /etc/crontab && [ -d /etc/NetworkManager ]; then
	echo "34 18 * * * root /opt/farm/ext/ip-monitor/cron/report.sh" >>/etc/crontab
fi
