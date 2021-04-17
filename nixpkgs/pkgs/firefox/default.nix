{ pkgs, ... }:

let
  # TODO: Inject the GL wrapper per-computer.
  nixGLNvidia = (
    pkgs.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/17c1ec63b969472555514533569004e5f31a921f.tar.gz;
      sha256 = "0yh8zq746djazjvlspgyy1hvppaynbqrdqpgk447iygkpkp3f5qr";
    }}/nixGL.nix" {}
  ).nixGLNvidia;
  wrappedFirefox = pkgs.writeScriptBin "firefox" ''
    #!${pkgs.stdenv.shell}
    ${nixGLNvidia}/bin/nixGLNvidia ${pkgs.firefox}/bin/firefox "$@"
  '';
  wrappedPkg = pkgs.symlinkJoin {
    name = "firefox";
    paths = [ wrappedFirefox pkgs.firefox ];
  };
in
{
  home.packages = [ wrappedPkg ];
}
