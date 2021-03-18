#!/usr/bin/env bash

prg=$(compgen -c | grep -v fzf | sort -u | fzf --layout=reverse)

i3-msg -t command exec "$prg"
