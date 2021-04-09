#!/usr/bin/env bash

export PATH="$HOME/.nix-profile/bin:$PATH"

text_files="$(find "${HOME}/texts" -type f \( -name '*.pdf' -o -name '*.html' \) -printf '%P\n' | sed 's/^/texts\//')"
book_files="$(find "${HOME}/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"

files="${text_files}\n${book_files}"
selected=$(printf "%s" "$files" | fzf --layout=reverse)

if [[ -z "$selected" ]]; then
	exit 1
fi

filepath="${HOME}/${selected}"

if [[ "$filepath" == *.pdf ]]; then
	i3-msg -t command exec "\"$(which evince) '${filepath}'\""
elif [[ "$filepath" == *.html ]]; then
	i3-msg -t command exec "\"$(which firefox) '${filepath}'\""
elif [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
	i3-msg -t command exec "\"$(which foliate) '${filepath}'\""
fi
