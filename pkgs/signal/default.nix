{ signal-desktop-bin }:

signal-desktop-bin.overrideAttrs (old: {
  preFixup = old.preFixup + ''
    substituteInPlace $out/share/applications/signal.desktop \
      --replace bin/signal-desktop 'bin/signal-desktop --use-tray-icon'
  '';
})
