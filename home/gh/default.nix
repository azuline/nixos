{ pkgs, ... }:

{
  home.packages = [ pkgs.gitAndTools.gh ];
  xdg.configFile."gh/config.yml".source = ./config.yml;
}
