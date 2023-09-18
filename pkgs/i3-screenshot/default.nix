{ pkgs }:

pkgs.writeShellScriptBin "i3-screenshot" ''
  ${pkgs.coreutils}/bin/mkdir -p "$HOME/images/Screenshots"

  # Use `-` instead of `:` because syncthing can't sync colons to Android.
  filename="$HOME/images/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

  case "$1" in
  select)
    ${pkgs.maim}/bin/maim --select "$filename"
    ;;
  screen)
    ${pkgs.maim}/bin/maim "$filename"
    ;;
  *)
    echo "Argument required: select, screen"
    exit 1
  esac

  ${pkgs.xclip}/bin/xclip -sel c -t image/png -i "$filename"
''
