# https://gist.github.com/lukalot/fcbf3216ad13b8303ab0947af0d5abd5
{ pkgs, ... }:
let
  pname = "cursor";
  version = "0.40.3";
  src = pkgs.fetchurl {
    # WARNING: Not pointed to a pinned version.
    url = "https://downloader.cursor.sh/linux/appImage/x64";
    hash = "sha256-CD6bQ4T8DhJidiOxNRgRDL4obfEZx7hnO0VotVb6lDc=";
  };
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share

    # Ensure the binary exists and create a symlink if it doesn't already exist
    if [ -e ${appimageContents}/AppRun ]; then
      install -m 755 -D ${appimageContents}/AppRun $out/bin/${pname}-${version}
      if [ ! -L $out/bin/${pname} ]; then
        ln -s $out/bin/${pname}-${version} $out/bin/${pname}
      fi
    else
      echo "Error: Binary not found in extracted AppImage contents."
      exit 1
    fi
  '';
  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
  ];
  # vscode likes to kill the parent so that the
  # gui application isn't attached to the terminal session
  dieWithParent = false;
  extraPkgs = pkgs: with pkgs; [
    unzip
    autoPatchelfHook
    asar
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    (buildPackages.wrapGAppsHook.override { inherit (buildPackages) makeWrapper; })
  ];
}
