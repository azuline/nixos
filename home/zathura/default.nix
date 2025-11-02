{ pkgs, specialArgs, themeColors, ... }:

{
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;
    options = {
      default-bg = themeColors.ui.background;
      default-fg = themeColors.ui.foreground;
      font =
        if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor != null then
          "Source Code Pro 12"
        else if specialArgs.sys.host == "haiqin" then
          "Source Code Pro 16"
        else if specialArgs.sys.host == "neptune" then
          "Source Code Pro 12"
        else
          throw "Unsupported host in zathura.";
      inputbar-bg = themeColors.primary.shade2;
      inputbar-fg = themeColors.terminal.color7;
      statusbar-bg = themeColors.ui.background;
      statusbar-fg = themeColors.ui.foreground;
      highlight-color = themeColors.terminal.color11;
      highlight-active-color = themeColors.ui.background;
      highlight-fg = themeColors.terminal.color14;
      render-loading-bg = themeColors.ui.background;
      render-loading-fg = themeColors.ui.foreground;
      recolor-lightcolor = themeColors.ui.background;
      recolor-darkcolor = themeColors.ui.foreground;
      recolor = false;
      index-bg = themeColors.ui.background;
      index-fg = themeColors.ui.foreground;
      index-active-bg = themeColors.primary.shade2;
      index-active-fg = themeColors.ui.foreground;
      window-title-home-tilde = true;
      selection-clipboard = "clipboard";
      # Otherwise, in files with mismatching page sizes (common in artbooks
      # etc), it's impossible to scroll.
      scroll-page-aware = true;
    };
  };
}
