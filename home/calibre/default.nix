{ pkgs, ... }:

{
  home.packages = [ pkgs.calibre ];
  xdg.configFile."calibre/viewer-webengine.json".source = ./viewer-webengine.json;
}
