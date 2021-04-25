{ pkgs, ... }:

let
  wrappedKitty = pkgs.writeScriptBin "kitty" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.nixGLNvidia}/bin/nixGLNvidia ${pkgs.kitty}/bin/kitty "$@"
  '';
  wrappedPkg = pkgs.symlinkJoin {
    name = "kitty";
    paths = [ wrappedKitty pkgs.kitty ];
  };
in
{
  home.packages = [ wrappedPkg ];
  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
}
