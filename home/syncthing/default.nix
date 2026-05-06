{ lib, pkgs, ... }:

lib.mkIf (!pkgs.stdenv.isDarwin) {
  services.syncthing.enable = true;
}
