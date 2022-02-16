{ pkgs, ... }:

let
  i3-clear-clipboard = pkgs.writeScriptBin "i3-clear-clipboard" ''
    #!/usr/bin/env bash

    echo -n "" | xclip -sel c
    echo -n "" | xclip -sel p
    echo -n "" | xclip -sel s
  '';
in
{
  home.packages = [ i3-clear-clipboard ];
}
