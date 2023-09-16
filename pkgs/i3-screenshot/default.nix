{ pkgs }:

pkgs.writeShellScriptBin "i3-screenshot" ''
  # Use `-` instead of `:` because syncthing can't sync colons to Android.
  filename=~/images/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
  case "$1" in

  select)
    ${pkgs.maim}/bin/maim --select "$filename"
    ;;
  screen)
    ${pkgs.maim}/bin/maim "$filename"
    ;;
  esac

  ${pkgs.xclip}/bin/xclip -sel c -t image/png -i "$filename"
''
