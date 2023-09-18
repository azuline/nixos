{ writeShellScriptBin }:

writeShellScriptBin "i3-clear-clipboard" ''
  echo -n "" | xclip -sel c
  echo -n "" | xclip -sel p
  echo -n "" | xclip -sel s
''
