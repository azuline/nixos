{ pkgs, ... }:

let
  # TODO: Inject the GL wrapper per-computer.
  nixGLNvidia = (
    pkgs.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/17c1ec63b969472555514533569004e5f31a921f.tar.gz;
      sha256 = "0yh8zq746djazjvlspgyy1hvppaynbqrdqpgk447iygkpkp3f5qr";
    }}/nixGL.nix" {}
  ).nixGLNvidia;
  wrappedAlacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.stdenv.shell}
    ${nixGLNvidia}/bin/nixGLNvidia ${pkgs.alacritty}/bin/alacritty "$@"
  '';
in
{
  programs.alacritty = {
    enable = true;
    package =
      pkgs.symlinkJoin {
        name = "alacritty";
        paths = [ wrappedAlacritty pkgs.alacritty ];
      };
    settings = {
      window = {
        padding = {
          x = 12;
          y = 12;
        };
      };
      font = {
        normal = {
          family = "Source Code Pro";
        };
        size = 12.0;
      };
      background_opacity = 0.85;
      colors = {
        normal = {
          black = "#48487c";
          blue = "#7986e7";
          cyan = "#82b1ff";
          green = "#8bd649";
          magenta = "#c792ea";
          red = "#f77669";
          white = "#d9f5dd";
          yellow = "#ffcb6b";
        };
        bright = {
          black = "#697196";
          blue = "#8eace3";
          cyan = "#89ddff";
          green = "#c3e88d";
          magenta = "#939ede";
          red = "#ff5370";
          white = "#eeffff";
          yellow = "#f1e655";
        };
        cursor = {
          cursor = "#ffffff";
          text = "#eeffff";
        };
        primary = {
          background = "#090910";
          foreground = "#eeffff";
        };
        selection = {
          background = "#232344";
          text = "#bbbbbb";
        };
      };
    };
  };
}
