{ pkgs }:

# Currently hardcodes the ID of the GPU bus (A) we use on splendor.
pkgs.writeShellScriptBin "bar-gpu" ''
  /run/current-system/sw/bin/nvidia-smi \
    --id=00000000:0A:00.0 \
    --query-gpu=utilization.gpu \
    --format=csv,noheader,nounits \
    | ${pkgs.gawk}/bin/awk '{ printf "0.%02i", $1}'
''
