{ pkgs, specialArgs, themeColors, ... }:

let
  colorsTheme = ''
    * {
        background-color:       #00000000; /* Transparent */
        background-selected:    ${themeColors.primary.shade3};
        foreground:             ${themeColors.ui.foreground};
        foreground-highlighted: ${themeColors.primary.shade6};
        foreground-error:       ${themeColors.terminal.color9};
        border:                 ${themeColors.primary.shade5};
    }

    window {
        background-color: ${themeColors.ui.background};
        border-color: var(border);
    }
    element {
        text-color: var(foreground);
    }
    element selected {
        background-color: var(background-selected);
    }
    element-text {
        highlight: var(foreground-highlighted);
        text-color: var(foreground);
    }
    element-icon {
        text-color: var(foreground);
    }
    textbox {
        text-color: var(foreground);
    }
    listview {
        border-color: var(border);
        border:       0;
    }
    scrollbar {
        handle-color: var(border);
    }
    message {
        border-color: var(border);
        border:       0;
    }
    sidebar {
        border-color: var(border);
        border:       0;
    }
    button {
        text-color: var(foreground);
    }
    button selected {
        background-color: var(background-selected);
        text-color:       var(foreground);
    }
    inputbar {
        text-color: var(foreground);
    }
    case-indicator {
        text-color: var(foreground);
    }
    entry {
        text-color: var(foreground);
    }
    prompt {
        text-color: var(foreground);
    }
    textbox-prompt-colon {
        margin:           0px 0.3000em 0.0000em 0.0000em;
        expand:           false;
        str:              ":";
        text-color:       inherit;
    }
    error-message {
        text-color:       var(foreground);
    }
  '';
  splendorSpacingTheme = ''
    element {
      padding: 12px;
      spacing: 10px;
    }
    inputbar {
      padding: 12px;
    }
  '';
  haiqinSpacingTheme = ''
    element {
      padding: 16px;
      spacing: 14px;
    }
    inputbar {
      padding: 16px;
    }
  '';
  neptuneSpacingTheme = ''
    element {
      padding: 12px;
      spacing: 10px;
    }
    inputbar {
      padding: 12px;
    }
  '';
  theme = pkgs.writeText "theme.rasi" ''
    ${colorsTheme}
    * {
      spacing: 0;
    }
    listview {
      lines: 12;
    }
    window {
      padding: 0;
      width:   960px;
      border:  5px;
    }
    inputbar {
      children: [ "prompt", "textbox-prompt-colon", "entry" ];
    }
    ${
      if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor != null then
        splendorSpacingTheme
      else if specialArgs.sys.host == "haiqin" then
        haiqinSpacingTheme
      else if specialArgs.sys.host == "neptune" then
        neptuneSpacingTheme
      else
        throw "Unsupported host in rofi."
    }
  '';
in
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,run,ssh,drun";
      show-icons = true;
      cycle = false;
      terminal = "kitty";
      ssh-client = "ssh";
      icon-theme = "Papirus-Dark";
      display-drun = "Launch";
      font = (
        if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor != null then
          "Roboto 14"
        else if specialArgs.sys.host == "haiqin" then
          "Roboto 18"
        else if specialArgs.sys.host == "neptune" then
          "Roboto 14"
        else
          throw "Unsupported host in rofi."
      );
    };
    theme = "${theme}";
  };
}
