{ specialArgs, ... }:

{
  services.picom = {
    enable = specialArgs.sys.nixos;
  };
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
