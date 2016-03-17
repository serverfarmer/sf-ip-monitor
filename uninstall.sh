#!/bin/sh

if grep -q /opt/farm/ext/ip-monitor/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/ip-monitor\/cron/d" /etc/crontab
fi
