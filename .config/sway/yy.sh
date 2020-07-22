#!/usr/bin/env bash

KNOW_DIR=$HOME/know

books="$(find $KNOW_DIR/books -type f -name '*.pdf' -printf 'books/%P\n')"
papers="$(find $KNOW_DIR/papers -type f -name '*.pdf' -printf 'papers/%P\n')"
webpages="$(find $KNOW_DIR/webpages -type f -name '*.html' -printf 'webpages/%P\n')"

selected=$(printf "${books}\n${papers}\n${webpages}\n" | fzf --layout=reverse)

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
