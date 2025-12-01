{ pkgs, srcs, ... }:
let
  pname = "handy";
  version = "0.6.4";
  src = srcs.handy-src;
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    # Install desktop file
    install -m 444 -D ${appimageContents}/Handy.desktop $out/share/applications/handy.desktop
    substituteInPlace $out/share/applications/handy.desktop \
      --replace-quiet 'Exec=handy' 'Exec=${pname} --force-device-scale-factor=1.5'

    # Install icons if they exist
    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share
    fi
  '';
}
