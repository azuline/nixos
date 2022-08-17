{ pkgs, ... }:

let
  inherit (pkgs) callPackage fetchurl;
  discord = callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.19";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-GfSyddbGF8WA6JmHo4tUM27cyHV5kRAyrEiZe1jbA5A=";
    };
  };
in
{
  # RIP in neptune. Doesn't work.
  home.packages = [ discord ];
}
