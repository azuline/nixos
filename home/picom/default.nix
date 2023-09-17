{ specialArgs, ... }:

{
  services.picom.enable = true;
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
