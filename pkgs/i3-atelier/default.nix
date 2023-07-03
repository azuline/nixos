{ pkgs }:

{
  opener = pkgs.writeShellScriptBin "i3-atelier-opener" ''
    files="$(find "$HOME/atelier/_store" -type f \( -name '*.pdf' -o -name '*.html' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n')"
    selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 2 --delimiter '/')

    [[ -z "$selected" ]] && exit 1

    filepath="$(printf '%q' "$HOME/atelier/_store/$selected")"

    if [[ "$filepath" == *.pdf ]]; then
      i3-msg -t command exec \""evince $filepath"\"
    elif [[ "$filepath" == *.html ]]; then
      i3-msg -t command exec \""firefox $filepath"\"
    elif [[ "$filepath" == *.epub ]] || [[ "$filepath" == *.azw3 ]]; then
      i3-msg -t command exec \""ebook-viewer $filepath"\"
    fi
  '';
  identifier = pkgs.writeShellScriptBin "i3-atelier-identifier" ''
    files="$(find "$HOME/atelier/_store" -type f \( -name '*.pdf' -o -name '*.html' -o -name '*.epub' -o -name '*.azw3' \) -printf '%P\n')"
    selected=$(printf '%s' "$files" | fzf --layout=reverse --with-nth 2 --delimiter '/')
    [[ -z "$selected" ]] && exit 1
    echo "$(dirname "$selected")" | tr -d '\n' | nohup xclip -sel c
  '';
}
