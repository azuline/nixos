#!/usr/bin/env bash

KNOW_DIR=$HOME/texts

files="$(find $KNOW_DIR -type f \( -name '*.pdf' -o -name '*.html' \) -printf '%P\n')"

selected=$(printf "%s" "$files" | fzf --layout=reverse)

if [[ -z "$selected" ]]; then
	exit 1
fi

filepath="${KNOW_DIR}/${selected}"

if [[ "$filepath" == *.pdf ]]; then
	evince "$filepath" &
elif [[ "$filepath" == *.html ]]; then
	firefox "$filepath" &
fi

disown
