{ pkgs, specialArgs, themeColors, ... }:

let
  colors = ''
    ###
    ### Colors
    ###
    background ${themeColors.ui.background}
    foreground ${themeColors.ui.foreground}
    selection_background ${themeColors.primary.shade3}
    selection_foreground ${themeColors.terminal.color7}
    cursor ${themeColors.ui.foreground}
    cursor_text_color ${themeColors.ui.background}
    color0 ${themeColors.terminal.color0}
    color8 ${themeColors.terminal.color8}
    color1 ${themeColors.terminal.color1}
    color9 ${themeColors.terminal.color9}
    color2 ${themeColors.terminal.color2}
    color10 ${themeColors.terminal.color10}
    color3 ${themeColors.terminal.color3}
    color11 ${themeColors.terminal.color11}
    color4 ${themeColors.terminal.color4}
    color12 ${themeColors.terminal.color12}
    color5 ${themeColors.terminal.color5}
    color13 ${themeColors.terminal.color13}
    color6 ${themeColors.terminal.color6}
    color14 ${themeColors.terminal.color14}
    color7 ${themeColors.terminal.color7}
    color15 ${themeColors.terminal.color15}
    active_border_color ${themeColors.primary.shade4}
    inactive_border_color ${themeColors.primary.shade2}
  '';

  config =
    if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor != null then
      builtins.readFile ./kitty.conf
      + colors
      + ''
        font_size 15.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "sunrise" then
      builtins.readFile ./kitty.conf
      + colors
      + ''
        font_size 14.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "haiqin" then
      builtins.readFile ./kitty.conf
      + colors
      + ''
        font_size 22.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "neptune" then
      builtins.readFile ./kitty.conf
      + colors
      + ''
        font_size 15.0
        window_padding_width 8
      ''
    else
      throw "Unsupported host in kitty.";
in
{
  programs.kitty.enable = true;
  xdg.configFile."kitty/kitty.conf".text = config;
}
