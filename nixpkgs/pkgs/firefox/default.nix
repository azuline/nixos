{ pkgs, ... }:

let
  wrappedFirefox = pkgs.writeScriptBin "firefox" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.nixGLBin} ${pkgs.firefox}/bin/firefox "$@"
  '';
  wrappedPkg = pkgs.symlinkJoin {
    name = "firefox";
    paths = [ wrappedFirefox pkgs.firefox ];
  };
in
{
  home.packages = [ wrappedPkg ];
}
