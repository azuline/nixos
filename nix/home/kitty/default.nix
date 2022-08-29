{ pkgs, ... }:

{
  # Install kitty via pkg manager for graphics drivers.
  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
}
