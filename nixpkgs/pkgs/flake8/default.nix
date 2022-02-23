{ pkgs, ... }:

{
  home.packages = with pkgs; [ python39Packages.flake8 ];
  xdg.configFile."flake8".source = ./setup.cfg;
}
