{ pkgs, specialArgs, ... }:

let
  theme = specialArgs.sys.theme or "cool";

  # Palenight colors (cool theme)
  palenightColors = {
    black = "#292D3E";
    gray = "#3E4452";
    commentgray = "#9197BC";
    purple = "#C792EA";
  };

  # Gruvbox colors (warm theme)
  gruvboxColors = {
    black = "#282828";
    gray = "#3c3836";
    commentgray = "#928374";
    purple = "#d3869b";
  };

  colors = if theme == "warm" then gruvboxColors else palenightColors;

  tmuxConfig = builtins.readFile ./tmux.conf;
  tmuxConfigWithColors = builtins.replaceStrings
    [
      "set -gq @black '#292D3E'"
      "set -gq @gray '#3E4452'"
      "set -gq @commentgray '#9197BC'"
      "set -gq @purple '#C792EA'"
    ]
    [
      "set -gq @black '${colors.black}'"
      "set -gq @gray '${colors.gray}'"
      "set -gq @commentgray '${colors.commentgray}'"
      "set -gq @purple '${colors.purple}'"
    ]
    tmuxConfig;
in
{
  programs.tmux = {
    enable = true;
    terminal = "screen";
    keyMode = "vi";
    extraConfig = tmuxConfigWithColors;
  };
}
