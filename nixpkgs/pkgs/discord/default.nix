{ pkgs, ... }:

let
  inherit (pkgs) callPackage fetchurl;
  discord = callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.18";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-BBc4n6Q3xuBE13JS3gz/6EcwdOWW57NLp2saOlwOgMI=";
    };
  };
in
{
  # RIP in neptune. Doesn't work.
  home.packages = [ discord ];
}
