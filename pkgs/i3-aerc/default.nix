{ tmux, coreutils, ripgrep, writeShellScriptBin }:

writeShellScriptBin "i3-aerc" ''
  exists="$(${tmux}/bin/tmux ls | ${coreutils}/bin/cut -d: -f1 | ${ripgrep}/bin/rg aerc)"
  if [ -z "$exists" ]; then
    ${tmux}/bin/tmux new-session -s aerc aerc
  else
    ${tmux}/bin/tmux attach -t aerc
  fi
''
