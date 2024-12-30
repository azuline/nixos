{ config, specialArgs, ... }:

let
  karabinerConfig = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/karabiner/config";
in
{
  home.file.".config/karabiner".source = karabinerConfig;
}
