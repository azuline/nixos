{ writeShellScriptBin, ddcutil, gawk, gnugrep }:

writeShellScriptBin "bar-ddcutil" ''
  export PATH="${ddcutil}/bin:${gnugrep}/bin:${gawk}/bin:$PATH"
  set -euo pipefail

  VCP_CODE=10
  DISPLAY=1

  current="$(ddcutil getvcp $VCP_CODE --display $DISPLAY | grep 'Brightness' | awk '{print $9}' | grep -o '[0-9]*')"
  
  case "$1" in
    get)
      echo "$current"
      ;;
    inc)
      ddcutil setvcp $VCP_CODE "$((current + 5))" --display $DISPLAY
      ;;
    dec)
      ddcutil setvcp $VCP_CODE "$((current - 5))" --display $DISPLAY
      ;;
    *)
      echo "Usage: $0 {get|inc|dec}"
      ;;
  esac
''
