#!/bin/sh

wget -q -T 5 -O - http://checkip.dyndns.org |sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g'
