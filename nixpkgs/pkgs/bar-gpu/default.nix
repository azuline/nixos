{ pkgs, ... }:

let
  bar-gpu = pkgs.writeScriptBin "bar-gpu" ''
    #!/bin/bash

    /usr/bin/nvidia-smi \
      --query-gpu=utilization.gpu \
      --format=csv,noheader,nounits \
      | /usr/bin/awk '{ printf "·  0.%02i  ", $1}'
  '';
in
{
  home.packages = [ bar-gpu ];
}
