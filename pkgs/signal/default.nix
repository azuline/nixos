{
  signal-desktop,
  symlinkJoin,
  makeWrapper,
}:

symlinkJoin {
  name = "signal-desktop-${signal-desktop.version}";
  paths = [ signal-desktop ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/signal-desktop \
      --add-flags "--use-tray-icon"
  '';
}
