{ writeShellScriptBin }:

writeShellScriptBin "i3-yy" ''
  book_files="$(find "$HOME/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"
  zotero_files="$(find "$HOME/Zotero/storage" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' -o -name '*.html' \) -printf '%P\n' | sed 's/^/Zotero\/storage\//')"
  atelier_files="$(find "$HOME/atelier/_store" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' -o -name '*.html' \) -printf '%P\n' | sed 's/^/atelier\/_store\//')"

  files="$zotero_files\n$book_files\n$atelier_files"
  selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 1.. --delimiter '/')

  [[ -z "$selected" ]] && exit 1

  filepath=$(printf '%q' "$HOME/$selected")

  if [[ "$filepath" == *.pdf ]] || [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
    i3-msg -t command exec \""zathura $filepath"\"
  elif [[ "$filepath" == *.html ]]; then
    i3-msg -t command exec \""firefox $filepath"\"
  fi
''
