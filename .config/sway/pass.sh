#!/bin/bash

file=$(find $HOME/.password-store -type f -name '*.gpg' -printf '%P\n' | sed 's/.gpg$//' | fzf --layout=reverse)

if [[ -z "$file" ]]; then
    exit 1
fi

data="$(pass $file)"
password=$(echo "$data" | head -n1)
fields=$(echo "$data" | tail -n+2)

choice=$(printf "password: ********\n${fields}\n" | fzf --layout=reverse)

echo $choice

if [[ "$choice" = "password: ********" ]]; then
    echo $password | wl-copy -n
else
    echo $choice | awk -F': ' '{$1="";print substr($0,2)}' | wl-copy -n
fi
