#!/bin/sh

/usr/bin/cat /proc/loadavg | /usr/bin/awk '{print "  "$1"  "$2"  "$3"  "}'
