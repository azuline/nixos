{ writeShellScriptBin }:

writeShellScriptBin "i3-atelier-opener" ''
  cd "$HOME/atelier" || exit 1
  files="$(find . -type f \( -name '*.tex' -o -name '*.md' \) -not -name '*.gen.tex' -not -name '*.gen.md' -printf '%P\n' | grep -v '^archive')"
  selected=$(printf '%s' "$files" | fzf --layout=reverse)
  [[ -z "$selected" ]] && exit 1
  # Need to load bashrc for the LS_COLORS envvar. Later, move that envvar to
  # the Vim derivation.
  bash -ic "vim '$selected'"
''
