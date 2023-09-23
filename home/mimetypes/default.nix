{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Look in ~/.nix-profile/share/applications
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-awk" = [ "nvim.desktop" ];
      "application/x-bittorrent" = [ "tremotesf.desktop" ];
      "audio/flac" = [ "mpv.desktop" ];
      "audio/ogg" = [ "mpv.desktop" ];
      "audio/x-opus+ogg" = [ "mpv.desktop" ];
      "image/bif" = [ "nsxiv.desktop" ];
      "image/heic" = [ "nsxiv.desktop" ];
      "image/jpeg" = [ "nsxiv.desktop" ];
      "image/png" = [ "nsxiv.desktop" ];
      "image/tiff" = [ "nsxiv.desktop" ];
      "image/webp" = [ "nsxiv.desktop" ];
      "text/markdown" = [ "nvim.desktop" ];
      "text/*" = [ "nvim.desktop" ];
      "text/x-lua" = [ "nvim.desktop" ];
      "video/mp4" = [ "mpv-fullscreen.desktop" ];
      "video/x-matroska" = [ "mpv-fullscreen.desktop" ];
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
