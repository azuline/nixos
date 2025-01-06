{ config, specialArgs, ... }:

let
  ghosttyConfig = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/ghostty/config";
in
{
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ghosttyConfig;
}
