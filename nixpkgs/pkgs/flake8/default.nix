{ pkgs, ... }:

{
  xdg.configFile."flake8".source = ./setup.cfg;
}
