#!/usr/bin/env bash

uptime | grep -ohe 'load average[s:][: ].*' | awk '{ print $3" "$4" "$5"," }' | sed 's/,//g'
