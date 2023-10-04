{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Look in ~/.nix-profile/share/applications
      "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "application/vnd.amazon.mobi8-ebook" = [ "org.pwmt.zathura.desktop" ];
      "application/vnd.comicbook-rar" = [ "org.pwmt.zathura.desktop" ];
      "application/vnd.comicbook+zip" = [ "org.pwmt.zathura.desktop" ];
      "application/x-awk" = [ "nvim.desktop" ];
      "application/x-bittorrent" = [ "tremotesf.desktop" ];
      "application/x-mobipocket-ebook" = [ "org.pwmt.zathura.desktop" ];
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
