{ pkgs, lib, ... }:

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
    extraConfig = builtins.readFile ./aerc.conf;
    stylesets.palenight = builtins.readFile ./stylesets/palenight;
  };

  # Make a desktop file.
  xdg.desktopEntries.aerc = {
    name = "aerc";
    exec = "${pkgs.aerc-in-kitty}/bin/aerc-in-kitty";
  };
}
