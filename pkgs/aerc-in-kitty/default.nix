{
  kitty,
  tmux,
  coreutils,
  ripgrep,
  writeShellScriptBin,
}:

writeShellScriptBin "aerc-in-kitty" ''
  exists="$(${tmux}/bin/tmux ls | ${coreutils}/bin/cut -d: -f1 | ${ripgrep}/bin/rg aerc)"
  if [ -z "$exists" ]; then
    ${kitty}/bin/kitty ${tmux}/bin/tmux new-session -s aerc aerc
  else
    ${kitty}/bin/kitty ${tmux}/bin/tmux attach -t aerc
  fi
''
