{ writeShellScriptBin, ddcutil, gawk, gnugrep }:

writeShellScriptBin "bar-ddcutil" ''
  export PATH="${ddcutil}/bin:${gawk}/bin:${gnugrep}/bin:$PATH"
  set -euo pipefail
  ddcutil getvcp 10 | grep 'Brightness' | awk '{print $9}' | grep -o '[0-9]*'
''
