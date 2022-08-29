{ pkgs }:

pkgs.writeShellScriptBin "sway-yy" ''
  text_files="$(find "$HOME/texts" -type f \( -name '*.pdf' -o -name '*.html' \) -printf '%P\n' | sed 's/^/texts\//')"
  book_files="$(find "$HOME/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"

  files="$text_files\n$book_files"
  selected=$(printf '%s' "$files" | fzf --layout=reverse)

  if [[ -z "$selected" ]]; then
  	exit 1
  fi

  filepath=$(printf '%q' "$HOME/$selected")

  if [[ "$filepath" == *.pdf ]]; then
  	swaymsg -t command exec \""evince $filepath"\"
  elif [[ "$filepath" == *.html ]]; then
  	swaymsg -t command exec \""firefox $filepath"\"
  elif [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
  	swaymsg -t command exec \""ebook-viewer $filepath"\"
  fi
''
