{ pkgs }:

pkgs.signal-desktop.overrideAttrs (
  old: rec {
    preFixup = old.preFixup + ''
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace bin/signal-desktop 'bin/signal-desktop --use-tray-icon'
    '';
  }
)
