#!/bin/sh

if grep -q /opt/sf-ip-monitor/cron /etc/crontab; then
	sed -i -e "/\/opt\/sf-ip-monitor\/cron/d" /etc/crontab
fi
