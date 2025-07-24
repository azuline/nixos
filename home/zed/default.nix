{
  pkgs,
  config,
  specialArgs,
  ...
}:

let
  zedDir = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/zed";
in
{
  home.packages = [ pkgs.zed-editor ];
  xdg.configFile = {
    "zed/settings.json".source = "${zedDir}/settings.json";
  };
}
