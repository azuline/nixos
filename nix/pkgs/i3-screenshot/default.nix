{ pkgs }:

pkgs.writeShellScriptBin "i3-screenshot" ''
  #!/usr/bin/env bash

  filename=~/images/scrots/$(date +%Y-%m-%d_%H:%M:%S).png
  case "$1" in

  select)
    maim --select "$filename"
    ;;
  screen)
    maim "$filename"
    ;;
  esac

  xclip -sel c -t image/png -i "$filename"
''
