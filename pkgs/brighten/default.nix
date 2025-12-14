{
  writeShellScriptBin,
  coreutils,
  ddcutil,
  gawk,
  gnugrep,
}:

writeShellScriptBin "brighten" ''
  export PATH="${coreutils}/bin:${ddcutil}/bin:${gnugrep}/bin:${gawk}/bin:$PATH"
  set -euo pipefail

  VCP_CODE=10
  BUS="$2"

  CACHEDIR="$HOME/.cache/brighten"
  CACHEFILE="$CACHEDIR/$BUS"
  mkdir -p "$CACHEDIR"

  update_cachefile() {
    echo "$(ddcutil getvcp $VCP_CODE --bus $BUS | grep 'Brightness' | awk '{print $9}' | grep -o '[0-9]*')" > "$CACHEFILE"
  }

  if [ ! -f "$CACHEFILE" ]; then
    update_cachefile
  fi

  case "$1" in
    get)
      cat "$CACHEFILE"
      ;;
    set)
      ddcutil setvcp $VCP_CODE "$3" --bus $BUS
      update_cachefile
      ;;
    inc)
      ddcutil setvcp $VCP_CODE "$((current + 10))" --bus $BUS
      update_cachefile
      ;;
    dec)
      ddcutil setvcp $VCP_CODE "$((current - 10))" --bus $BUS
      update_cachefile
      ;;
    *)
      echo "Usage: $0 {get|inc|dec}"
      ;;
  esac
''
