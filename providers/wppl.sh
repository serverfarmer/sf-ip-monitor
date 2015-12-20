#!/bin/sh

wget -q -T 5 -O - http://twojeip.wp.pl |grep "var ipadress" |sed "s/.*'\([0-9\.]*\)'.*/\1/g"
