{ pkgs, themeColors, ... }:

{
  home.packages = [ pkgs.nsxiv ];
  xresources.properties = {
    "Nsxiv.window.background" = themeColors.ui.background;
    "Nsxiv.window.foreground" = themeColors.ui.foreground;
    "Nsxiv.mark.foreground" = themeColors.terminal.color10;
    "Nsxiv.bar.font" = "Roboto";
  };
  xdg.configFile."nsxiv/exec/image-info".source = ./image-info;
}
