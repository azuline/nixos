{ pkgs, ... }:
let
  mySignal = pkgs.signal-desktop.overrideAttrs (oldAttrs: rec {
    preFixup = oldAttrs.preFixup + ''
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace bin/signal-desktop 'bin/signal-desktop --use-tray-icon'
    '';
  });
in
{
  home.packages = [
    mySignal
  ];
}
