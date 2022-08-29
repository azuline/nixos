{ pkgs }:

pkgs.writeScriptBin "sway-clear-clipboard" ''
  #!/usr/bin/env bash

  wl-copy --clear
  wl-copy --primary --clear
''
