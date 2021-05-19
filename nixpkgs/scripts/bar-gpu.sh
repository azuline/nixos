#!/bin/bash

/usr/bin/nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | /usr/bin/awk '{ printf "·  0.%02i  ", $1}'
