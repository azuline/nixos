{
  original,
  makeDesktopItem,
  symlinkJoin,
}:

let
  desktopItem = makeDesktopItem {
    name = "tremotesf";
    desktopName = "Transmission UI";
    exec = "env QT_SCALE_FACTOR=1.4 tremotesf %U";
    icon = "org.equeim.Tremotesf";
    categories = [
      "Network"
      "P2P"
    ];
    keywords = [
      "transmission"
      "tremotesf"
    ];
    startupNotify = true;
    startupWMClass = "tremotesf";
    mimeTypes = [
      "application/x-bittorrent"
      "x-scheme-handler/magnet"
    ];
  };
in
symlinkJoin {
  name = "tremotesf-with-desktop";
  paths = [ original ];
  postBuild = ''
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/tremotesf.desktop" "$out/share/applications/tremotesf.desktop"
  '';
}
