{ writeShellScriptBin, coreutils, maim, xclip }:

writeShellScriptBin "i3-screenshot" ''
  ${coreutils}/bin/mkdir -p "$HOME/images/Screenshots"

  # Use `-` instead of `:` because syncthing can't sync colons to Android.
  filename="$HOME/images/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

  case "$1" in
  select)
    ${maim}/bin/maim --select "$filename"
    ;;
  screen)
    ${maim}/bin/maim "$filename"
    ;;
  *)
    echo "Argument required: select, screen"
    exit 1
  esac

  ${xclip}/bin/xclip -sel c -t image/png -i "$filename"
''
