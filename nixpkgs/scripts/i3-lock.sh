#!/usr/bin/env bash

xss-lock --transfer-sleep-lock -- i3lock --nofork -i ~/.bg/lock.png --insidecolor=ffffff1c --ringcolor=ffffff3e --linecolor=ffffff00 --keyhlcolor=00000080 --ringvercolor=00000000 --separatorcolor=22222260 --insidevercolor=0000001c --ringwrongcolor=00000055 --insidewrongcolor=0000001c --verifcolor=00000000 --wrongcolor=ff000000 --timecolor=00000000 --datecolor=00000000 --layoutcolor=00000000 --ring-width=15 $@
