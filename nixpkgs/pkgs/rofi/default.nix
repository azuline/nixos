{ pkgs, ... }:

# TODO: Laptop conditional.
{
  xdg.configFile."rofi/config.rasi".source = ./desktop/config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./desktop/theme.rasi;
}
