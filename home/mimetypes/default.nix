{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Look in ~/.nix-profile/share/applications
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-bittorrent" = [ "tremotesf.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
      "image/png" = [ "feh.desktop" ];
      "text/x-lua" = [ "nvim.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/magnet" = [ "tremotesf.desktop" ];
      "x-scheme-handler/mailto" = [ "aerc.desktop" ];
      "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-www-browser" = [ "firefox.desktop" ];
    };
  };
}
