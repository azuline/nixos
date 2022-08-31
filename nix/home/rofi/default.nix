{ pkgs, specialArgs, ... }:

if specialArgs.sys.screen == "desktop" then
  {
    xdg.configFile."rofi/config.rasi".source = ./desktop/config.rasi;
    xdg.configFile."rofi/theme.rasi".source = ./desktop/theme.rasi;
  }
else if specialArgs.sys.screen == "laptop" then
  {
    xdg.configFile."rofi/config.rasi".source = ./laptop/config.rasi;
    xdg.configFile."rofi/theme.rasi".source = ./laptop/theme.rasi;
  }
else throw "Invalid screen variable in rofi."