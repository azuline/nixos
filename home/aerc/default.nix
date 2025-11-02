{ pkgs, lib, specialArgs, ... }:

let
  theme = specialArgs.sys.theme or "cool";
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
    extraBinds = builtins.readFile ./binds.conf;
    extraConfig =
      let
        aercConfig = builtins.readFile ./aerc.conf;
        styleset = if theme == "warm" then "gruvbox" else "palenight";
      in
        builtins.replaceStrings
          [ "styleset-name=palenight" ]
          [ "styleset-name=${styleset}" ]
          aercConfig;
    stylesets = {
      palenight = builtins.readFile ./stylesets/palenight;
      gruvbox = builtins.readFile ./stylesets/gruvbox;
    };
  };

  # Make a desktop file.
  xdg.desktopEntries.aerc = {
    name = "aerc";
    exec = "${pkgs.aerc-in-kitty}/bin/aerc-in-kitty";
  };
}
