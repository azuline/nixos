{ pkgs }:

pkgs.writeShellScriptBin "sway-clear-clipboard" ''
  wl-copy --clear
  wl-copy --primary --clear
''
