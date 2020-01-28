#!/bin/bash

file=$(find $HOME/.password-store -type f -name '*.gpg' -printf '%P\n' | sed 's/.gpg$//' | fzf --layout=reverse)

if [ -z "$file" ]; then
    exit 1
fi

data="$(pass $file)"

echo "password: ${data}" | fzf --layout=reverse | awk -F': ' '{$1="";print substr($0,2)}' | wl-copy

exit 0
