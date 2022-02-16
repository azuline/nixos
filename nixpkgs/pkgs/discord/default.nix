{ pkgs, ... }:

let
  inherit (pkgs) callPackage fetchurl;
  discord = callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.16";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "1s9qym58cjm8m8kg3zywvwai2i3adiq6sdayygk2zv72ry74ldai";
    };
  };
in
{
  # RIP in neptune. Doesn't work.
  home.packages = [ discord ];
}
