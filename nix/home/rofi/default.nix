{ pkgs, specialArgs, ... }:

{
  home.packages = if specialArgs.sys.nixos then [ pkgs.rofi ] else [ ];
} // (if specialArgs.sys.host == "splendor" then {
  xdg.configFile."rofi/config.rasi".source = ./desktop/config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./desktop/theme.rasi;
} else if specialArgs.sys.host == "haiqin" then {
  xdg.configFile."rofi/config.rasi".source = ./laptop/config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./laptop/theme.rasi;
} else throw "Invalid host in rofi.")
