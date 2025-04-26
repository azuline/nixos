{ writeShellScriptBin }:

writeShellScriptBin "i3-yy" ''
  book_files="$(find "$HOME/books" -type f \( -name '*.pdf' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n' | sed 's/^/books\//')"
  study_notes_pdfs="$(find "$HOME/studies/notes" -type f -name '*.pdf' -printf '%P\n' | sed 's/^/studies\/notes\//')"

  files="$book_files\n$study_notes_pdfs"
  selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 1.. --delimiter '/')

  [[ -z "$selected" ]] && exit 1

  filepath=$(printf '%q' "$HOME/$selected")

  if [[ "$filepath" == *.pdf ]] || [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
    i3-msg -t command exec \""zathura $filepath"\"
  elif [[ "$filepath" == *.html ]]; then
    i3-msg -t command exec \""firefox $filepath"\"
  fi
''
