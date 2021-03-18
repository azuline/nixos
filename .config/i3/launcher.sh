#!/usr/bin/env bash

prg=$(compgen -c | grep -v fzf | sort -u | fzf --layout=reverse)

exec setsid "$prg"
