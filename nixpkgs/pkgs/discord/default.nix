{ pkgs, srcs }:

pkgs.discord.overrideAttrs (_: {
  src = srcs.discord;
})
