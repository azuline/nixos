{ pkgs }:

pkgs.writeShellScriptBin "i3-yy" ''
  book_files="$(find "$HOME/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"
  zotero_files="$(find "$HOME/Zotero/storage" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' -o -name '*.html' \) -printf '%P\n' | sed 's/^/Zotero\/storage\//')"

  files="$zotero_files\n$book_files"
  selected=$(printf '%s' "$files" | fzf --layout=reverse)

  if [[ -z "$selected" ]]; then
    exit 1
  fi

  filepath=$(printf '%q' "$HOME/$selected")

  if [[ "$filepath" == *.pdf ]]; then
    i3-msg -t command exec \""zathura $filepath"\"
  elif [[ "$filepath" == *.html ]]; then
    i3-msg -t command exec \""firefox $filepath"\"
  elif [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
    i3-msg -t command exec \""ebook-viewer $filepath"\"
  fi
''
