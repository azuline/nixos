{ pkgs }:

pkgs.writeShellScriptBin "bar-gpu" ''
  /usr/bin/nvidia-smi \
    --query-gpu=utilization.gpu \
    --format=csv,noheader,nounits \
    | ${pkgs.gawk}/bin/awk '{ printf "0.%02i", $1}'
''
