{
  lib,
  pkgs,
  specialArgs,
  ...
}:

lib.mkIf (!pkgs.stdenv.isDarwin && specialArgs.sys.host != "haiqin") {
  services.syncthing.enable = true;
}
