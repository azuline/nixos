{ writeShellScriptBin }:

writeShellScriptBin "i3-yy" ''
  book_files="$(find "$HOME/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"
  atelier_store_files="$(find "$HOME/atelier/_store" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' -o -name '*.html' \) -printf '%P\n' | sed 's/^/atelier\/_store\//')"
  atelier_pdfs="$(find "$HOME/atelier" -type f -name '*.pdf' -printf '%P\n' | grep -v '^_store' | grep -v '^archive' | sed 's/^/atelier\//')"
  buddhism_notes_pdfs="$(find "$HOME/buddhism/notes" -type f -name '*.pdf' -printf '%P\n' | sed 's/^/buddhism\/notes\//')"

  files="$book_files\n$atelier_store_files\n$atelier_pdfs$buddhism_notes_pdfs"
  selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 1.. --delimiter '/')

  [[ -z "$selected" ]] && exit 1

  filepath=$(printf '%q' "$HOME/$selected")

  if [[ "$filepath" == *.pdf ]] || [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
    i3-msg -t command exec \""zathura $filepath"\"
  elif [[ "$filepath" == *.html ]]; then
    i3-msg -t command exec \""firefox $filepath"\"
  fi
''
