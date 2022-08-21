{ pkgs, ... }:

let
  sway-clear-clipboard = pkgs.writeScriptBin "sway-clear-clipboard" ''
    #!/usr/bin/env bash

    wl-copy --clear
    wl-copy --primary --clear
  '';
in
{
  home.packages = [ sway-clear-clipboard ];
}
