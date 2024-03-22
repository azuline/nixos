{ writeShellScriptBin }:

writeShellScriptBin "i3-atelier-identifier" ''
  files="$(find "$HOME/atelier/_store" -type f \( -name '*.pdf' -o -name '*.html' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n')"
  selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 2 --delimiter '/')
  [[ -z "$selected" ]] && exit 1
  echo "<$(dirname "$selected")>" | tr -d '\n' | nohup xclip -sel c >/dev/null 2>&1
''
