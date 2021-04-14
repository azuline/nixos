{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen";
    keyMode = "vi";
    extraConfig = (builtins.readFile ./tmux.conf);
  };
}
