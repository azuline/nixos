{ pkgs, lib, ... }:

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
      # We can't use --fs here because i3 doesn't support the hint that mpv
      # uses to determine the monitor to fullscreen on. Often, mpv would start
      # in the incorrect monitor if we use --fs.
      #
      # See https://github.com/mpv-player/mpv/issues/3852#issuecomment-362623569.
      #
      # So we instead assign the window a special title and then set fullscreen
      # enable in i3 config for that window title.
      exec = "mpv --force-window --player-operation-mode=pseudo-gui --title=mpv-fullscreen -- %U";
      icon = "mpv";
      categories = [
        "AudioVideo"
        "Audio"
        "Video"
        "Player"
        "TV"
      ];
      startupWMClass = "mpv";
      terminal = false;
    };
    postInstall = ''
      mkdir -p "$out/share/applications"
      cp "$desktopItem/share/applications/mpv-fullscreen.desktop" "$out/share/applications/mpv-fullscreen.desktop"
    '';
  };
in
{
  home.packages = lib.mkIf pkgs.stdenv.isLinux [ fullscreenDesktopItem ];
  programs.mpv = {
    enable = true;
    config = {
      demuxer-thread = "yes";
      demuxer-readahead-secs = "360";
      demuxer-max-bytes = "1000M";
      osd-font-size = 24;
      screenshot-format = "png";
      screenshot-png-compression = "9";
      screenshot-template = "%F - %wH-%wM-%wS";
      screenshot-directory = "~/images/Screenshots";
    };
  };
  xdg.configFile."mpv/input.conf".text = ''
    p show-text ''${playlist}
    Ctrl+Shift+> add playlist-pos 5
    Ctrl+Shift+< add playlist-pos -5
  '';
}
