{ pkgs, specialArgs, ... }:

let
  discord = pkgs.discord.overrideAttrs (_: rec {
    src = specialArgs.src.discord;
  });
in
{
  home.packages = [ discord ];
}
