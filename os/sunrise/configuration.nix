{ pkgs, self, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  networking = {
    hostName = "sunrise";
    computerName = "sunrise";
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;

  security.pam.enableSudoTouchIdAuth = true;

  environment = {
    systemPackages = with pkgs; [
      aerospace
      colima
      vim
      curl
      rectangle
      jq
    ];
    shells = [ pkgs.fish ];
    variables = {
      EDITOR = "nvim";
      XDG_RUNTIME_DIR = "/run/users/501";
    };
  };

  programs.fish.enable = true;
  programs.direnv.enable = true;
}
