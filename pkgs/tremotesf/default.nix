{ pkgs }:

# I can't type tremotesf. Too hard.
pkgs.tremotesf.overrideAttrs (old: {
  desktopItem = pkgs.makeDesktopItem {
    name = "tremotesf";
    desktopName = "Transmission UI";
    exec = "tremotesf %U";
    icon = "org.equeim.Tremotesf";
    categories = [ "Network" "P2P" ];
    keywords = [ "transmission" "tremotesf" ];
    startupNotify = true;
    startupWMClass = "tremotesf";
    mimeTypes = [ "application/x-bittorrent" "x-scheme-handler/magnet" ];
  };
  postInstall = ''
    mkdir -p "$out/share/applications"
    cp "$desktopItem/share/applications/tremotesf.desktop" "$out/share/applications/tremotesf.desktop"
  '';
})
