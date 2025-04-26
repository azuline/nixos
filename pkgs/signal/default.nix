{ signal-desktop }:

signal-desktop.overrideAttrs (old: {
  preFixup = ''
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace bin/signal-desktop 'bin/signal-desktop --use-tray-icon'
  '';
})
