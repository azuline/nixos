{ pkgs, specialArgs, ... }:

let
  # discord = pkgs.discord.overrideAttrs (old: rec {
  #   src = specialArgs.src.discord;
  # });
  discord = pkgs.callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.19";
    src = specialArgs.src.discord;
  };
in
{
  home.packages = [ discord ];
}
