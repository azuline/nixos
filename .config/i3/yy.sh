#!/usr/bin/env bash

KNOW_DIR=$HOME/texts

files="$(find $KNOW_DIR -type f \( -name '*.pdf' -o -name '*.html' \) -printf '%P\n')"

selected=$(printf "%s" "$files" | fzf --layout=reverse)

if [[ -z "$selected" ]]; then
	exit 1
fi

filepath="${KNOW_DIR}/${selected}"

if [[ "$filepath" == *.pdf ]]; then
	i3-msg -t command exec evince "$filepath"
elif [[ "$filepath" == *.html ]]; then
	i3-msg -t command exec firefox "$filepath"
fi
