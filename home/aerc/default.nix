{
  pkgs,
  lib,
  specialArgs,
  ...
}:

let
  theme = specialArgs.sys.theme;
  styleset = if theme == "warm" then "gruvbox" else "palenight";
in
# On Mac (work), just use builtin mail.
lib.mkIf pkgs.stdenv.isLinux {
  # Runtime dependencies for HTML/image filters.
  home.packages = with pkgs; [
    dante
    w3m
    pandoc
    catimg
  ];

  xdg.configFile."aerc/colorize.awk".source = ./colorize.awk;

  programs.aerc = {
    enable = true;
    stylesets = {
      palenight = builtins.readFile ./stylesets/palenight;
      gruvbox = builtins.readFile ./stylesets/gruvbox;
    };
    extraBinds = builtins.readFile ./binds.conf;
    extraConfig = builtins.replaceStrings [ "THEME_STYLESET" ] [ styleset ] (
      builtins.readFile ./aerc.conf
    );
  };

  # Make a desktop file.
  xdg.desktopEntries.aerc = {
    name = "aerc";
    exec = "${pkgs.aerc-in-kitty}/bin/aerc-in-kitty";
  };
}
