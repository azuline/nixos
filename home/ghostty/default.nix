{ config, specialArgs, themeColors, ... }:

let
  ghosttyConfig = ''
    macos-titlebar-style = hidden
    window-padding-x = 8
    window-padding-y = 8
    font-family = Source Code Pro
    font-size = 14
    confirm-close-surface = false
    quit-after-last-window-closed = true
    quit-after-last-window-closed-delay = 1s
    shell-integration = fish
    window-save-state = never
    macos-option-as-alt = true

    # Colors

    palette = 0=${themeColors.terminal.color0}
    palette = 1=${themeColors.terminal.color1}
    palette = 2=${themeColors.terminal.color2}
    palette = 3=${themeColors.terminal.color3}
    palette = 4=${themeColors.terminal.color4}
    palette = 5=${themeColors.terminal.color5}
    palette = 6=${themeColors.terminal.color6}
    palette = 7=${themeColors.terminal.color7}
    palette = 8=${themeColors.terminal.color8}
    palette = 9=${themeColors.terminal.color9}
    palette = 10=${themeColors.terminal.color10}
    palette = 11=${themeColors.terminal.color11}
    palette = 12=${themeColors.terminal.color12}
    palette = 13=${themeColors.terminal.color13}
    palette = 14=${themeColors.terminal.color14}
    palette = 15=${themeColors.terminal.color15}
    background = ${themeColors.ui.background}
    foreground = ${themeColors.ui.foreground}
    selection-background = ${themeColors.primary.shade3}
    selection-foreground = ${themeColors.terminal.color7}
    cursor-invert-fg-bg = true

    # Blur

    background-opacity = .92
    background-blur-radius = 20
  '';
in
{
  home.file."Library/Application Support/com.mitchellh.ghostty/config".text = ghosttyConfig;
}
