{ specialArgs, ... }:

{
  services.picom = {
    enable = specialArgs.sys.nixos;
    experimentalBackends = true;
  };
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
