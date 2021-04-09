{ pkgs, ... }:

let
  i3-lock = pkgs.writeScriptBin "i3-lock" (builtins.readFile ./i3-lock.sh);
  i3-pass = pkgs.writeScriptBin "i3-pass" (builtins.readFile ./i3-pass.sh);
  i3-yy = pkgs.writeScriptBin "i3-yy" (builtins.readFile ./i3-yy.sh);
in
{
  home.packages = [
    i3-lock
    i3-pass
    i3-yy
  ];
}
