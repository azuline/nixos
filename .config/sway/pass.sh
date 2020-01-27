#!/bin/bash

file=$(tree -Ffi $HOME/.password-store | grep '.gpg' | sed 's/.gpg$//g' | sed 's/^..//' | fzf --layout=reverse)

if [ -z "$file" ]; then
    exit 0
fi

data="$(pass $file)"
choice=$(echo "password: $data" | fzf --layout=reverse)

echo $choice | awk -F': ' '{print $2}' | wl-copy
