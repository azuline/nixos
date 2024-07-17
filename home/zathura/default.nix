{ pkgs, specialArgs, ... }:

{
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;
    options = {
      default-bg = "#090910";
      default-fg = "#eeffff";
      font =
        if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor then
          "Source Code Pro 12"
        else if specialArgs.sys.host == "haiqin" then
          "Source Code Pro 16"
        else if specialArgs.sys.host == "neptune" then
          "Source Code Pro 12"
        else throw "Unsupported host in zathura.";
      inputbar-bg = "#232344";
      inputbar-fg = "#bbbbbb";
      statusbar-bg = "#090910";
      statusbar-fg = "#eeffff";
      highlight-color = "#f1e655";
      highlight-active-color = "#090910";
      highlight-fg = "#89ddff";
      render-loading-bg = "#090910";
      render-loading-fg = "#eeffff";
      recolor-lightcolor = "#090910";
      recolor-darkcolor = "#eeffff";
      recolor = false;
      index-bg = "#090910";
      index-fg = "#eeffff";
      index-active-bg = "#232344";
      window-title-home-tilde = true;
      selection-clipboard = "clipboard";
      # Otherwise, in files with mismatching page sizes (common in artbooks
      # etc), it's impossible to scroll.
      scroll-page-aware = true;
    };
  };
}
