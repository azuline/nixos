{ pkgs }:

pkgs.writeShellScriptBin "bar-loadavg" ''
  ${pkgs.coreutils}/bin/cat /proc/loadavg \
    | ${pkgs.gawk}/bin/awk '{print $1"  "$2"  "$3}'
''
