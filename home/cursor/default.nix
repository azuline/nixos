{
  config,
  specialArgs,
  pkgs,
  ...
}:

let
  settings = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/cursor/settings.json";
in
{
  # TODO(revive)
  # home.packages = [ pkgs.code-cursor ];
  # For some reason, cursor can't read the Nix store?
  # xdg.configFile."Cursor/User/settings.json".source = settings;
}
