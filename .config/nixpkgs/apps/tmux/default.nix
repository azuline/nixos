{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux.extraConfig = (builtins.readFile ./tmux.conf);
}
