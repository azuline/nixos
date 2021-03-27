#!/usr/bin/env bash

prg=$(compgen -c | grep -v fzf | sort -u | fzf --layout=reverse)
full_prg=$(which "$prg")

i3-msg -t command exec "$full_prg"
