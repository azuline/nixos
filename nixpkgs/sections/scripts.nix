{ pkgs, ... }:

let
  bar-loadavg = pkgs.writeScriptBin "bar-loadavg" (builtins.readFile ../scripts/bar-loadavg.sh);
  bar-gpu = pkgs.writeScriptBin "bar-gpu" (builtins.readFile ../scripts/bar-gpu.sh);
  i3-clear-clipboard =
    pkgs.writeScriptBin "i3-clear-clipboard" (builtins.readFile ../scripts/i3-clear-clipboard.sh);
  i3-lock = pkgs.writeScriptBin "i3-lock" (builtins.readFile ../scripts/i3-lock.sh);
  i3-pass = pkgs.writeScriptBin "i3-pass" (builtins.readFile ../scripts/i3-pass.sh);
  i3-yy = pkgs.writeScriptBin "i3-yy" (builtins.readFile ../scripts/i3-yy.sh);
in
{
  home.packages = [
    bar-loadavg
    bar-gpu
    i3-clear-clipboard
    i3-lock
    i3-pass
    i3-yy
  ];
}
