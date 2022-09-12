{ pkgs, ... }:

{
  home.packages = [ pkgs.bashInteractive ];
  home.file.".bashrc".source = ../../etc/bashrc;
}
