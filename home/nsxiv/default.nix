{ pkgs, ... }:

{
  home.packages = [ pkgs.nsxiv ];
  xresources.properties = {
    "Nsxiv.window.background" = "#090910";
    "Nsxiv.window.foreground" = "#eeffff";
    "Nsxiv.mark.foreground" = "#8bd649";
    "Nsxiv.bar.font" = "Roboto";
  };
  xdg.configFile."nsxiv/exec/image-info".source = ./image-info;
}
