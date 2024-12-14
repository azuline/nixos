{ pkgs, lib, config, specialArgs, ... }:

{
  home.packages = [ pkgs.rose-cli ];

  xdg.configFile = lib.mkIf pkgs.stdenv.isLinux {
    "rose/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/rose/config.toml";
  };
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Application Support/rose/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/rose/config.toml";
  };

  # Ensure the Home Manager systemd services are enabled
  systemd.user.services.rose = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.rose-cli}/bin/rose fs mount --foreground";
      Restart = "always";
    };
    Unit = {
      After = "graphical-session-pre.target";
      PartOf = "graphical-session.target";
    };
  };
  launchd.agents.rose = {
    enable = true;
    config = {
      Label = "net.sunsetglow.rose";
      Program = "${pkgs.rose-cli}/bin/rose";
      ProgramArguments = [ "fs" "mount" "--foreground" ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
