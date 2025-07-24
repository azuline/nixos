{
  writeShellScriptBin,
  coreutils,
  gawk,
}:

writeShellScriptBin "bar-loadavg" ''
  ${coreutils}/bin/cat /proc/loadavg \
    | ${gawk}/bin/awk '{print $1"  "$2"  "$3}'
''
