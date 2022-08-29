{ pkgs, ... }:

{
  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;
  xdg.configFile."waybar/vpn.sh".source = ./vpn.sh;

  home.packages = [ pkgs.waybar ];
}
