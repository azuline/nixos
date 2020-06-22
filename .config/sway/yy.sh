#!/usr/bin/env bash

KNOW_DIR=$HOME/know

books="$(find $KNOW_DIR/books -type f -name '*.pdf' -printf 'books/%P\n')"
papers="$(find $KNOW_DIR/papers -type f -name '*.pdf' -printf 'papers/%P\n')"

selected=$(printf "${books}\n${papers}\n" | sed 's/\.pdf$//' | fzf --layout=reverse)

if [[ -z "$selected" ]]; then
	exit 1
fi

filepath="${KNOW_DIR}/${selected}.pdf"

evince "$filepath" &
disown
