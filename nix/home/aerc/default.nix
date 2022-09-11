{ pkgs, ... }:

{
  # Runtime dependencies for HTML/image filters.
  home.packages = with pkgs; [ dante w3m pandoc catimg ];

  programs.aerc = {
    enable = true;
    extraBinds = builtins.readFile ./binds.conf;
    extraConfig = builtins.readFile ./aerc.conf;
    stylesets.palenight = builtins.readFile ./stylesets/palenight;
  };

  xdg.configFile."aerc/colorize.awk".source = ./colorize.awk;
}
