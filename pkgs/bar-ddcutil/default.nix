{
  writeShellScriptBin,
  ddcutil,
  gawk,
  gnugrep,
}:

writeShellScriptBin "bar-ddcutil" ''
  export PATH="${ddcutil}/bin:${gnugrep}/bin:${gawk}/bin:$PATH"
  set -euo pipefail

  VCP_CODE=10
  BUS=11

  current="$(ddcutil getvcp $VCP_CODE --bus $BUS | grep 'Brightness' | awk '{print $9}' | grep -o '[0-9]*')"

  case "$1" in
    get)
      echo "$current"
      ;;
    inc)
      ddcutil setvcp $VCP_CODE "$((current + 10))" --bus $BUS
      ;;
    dec)
      ddcutil setvcp $VCP_CODE "$((current - 10))" --bus $BUS
      ;;
    *)
      echo "Usage: $0 {get|inc|dec}"
      ;;
  esac
''
