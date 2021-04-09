#!/usr/bin/env bash

BOOK_DIR=$HOME/books

files="$(find $BOOK_DIR -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n')"

selected=$(printf "%s" "$files" | fzf --layout=reverse)

if [[ -z "$selected" ]]; then
	exit 1
fi

filepath="${BOOK_DIR}/${selected}"

if [[ "$filepath" == *.pdf ]]; then
	evince "$filepath" &
elif [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
	foliate "$filepath" &
fi

disown
