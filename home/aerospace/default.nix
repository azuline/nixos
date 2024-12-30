{ config, specialArgs, ... }:

let
  aerospaceConfig = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/aerospace/aerospace.toml";
in
{
  home.file.".config/aerospace/aerospace.toml".source = aerospaceConfig;
}
