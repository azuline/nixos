{ pkgs, ... }:

{
  # NixGL is annoying!
  # home.packages = [ pkgs.picom ];
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
