{ pkgs, ... }:

let
  wrappedAlacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.nixGLBin} ${pkgs.alacritty}/bin/alacritty "$@"
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
        size = 24.0;
      };
      background_opacity = 0.85;
      colors = {
        normal = {
          black = "#30384c";
          blue = "#7986e7";
          cyan = "#82b1ff";
          green = "#8bd649";
          magenta = "#c792ea";
          red = "#f77669";
          white = "#d9f5dd";
          yellow = "#ffcb6b";
        };
        bright = {
          black = "#3e465b";
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
