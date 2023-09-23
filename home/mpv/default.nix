{ pkgs, ... }:

let
  # We want some mimetypes to launch in full screen, so we add a custom desktop
  # entry specifically for that.
  fullscreenDesktopItem = pkgs.stdenv.mkDerivation {
    pname = "mpv-fullscreen";
    version = "0.0.0";
    src = ./.;
    desktopItem = pkgs.makeDesktopItem {
      name = "mpv-fullscreen";
      desktopName = "mpv Fullscreen";
      exec = "mpv --force-window --player-operation-mode=pseudo-gui --fs -- %U";
      icon = "mpv";
      categories = [ "AudioVideo" "Audio" "Video" "Player" "TV" ];
      startupWMClass = "mpv";
    };
    postInstall = ''
      mkdir -p "$out/share/applications"
      cp "$desktopItem/share/applications/mpv-fullscreen.desktop" "$out/share/applications/mpv-fullscreen.desktop"
    '';
  };
in
{
  home.packages = [ fullscreenDesktopItem ];
  programs.mpv = {
    enable = true;
    config = {
      demuxer-thread = "yes";
      demuxer-readahead-secs = "120";
      demuxer-max-bytes = "500M";
      screenshot-format = "png";
      screenshot-png-compression = "9";
      screenshot-template = "%F - %wH-%wM-%wS";
      screenshot-directory = "~/images/Screenshots";
    };
  };
}
