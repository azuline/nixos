{ pkgs, ... }:

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
      curl
      jq
      vim
    ];
    shells = [ pkgs.fish ];
    variables = {
      EDITOR = "nvim";
    };
    extraInit = ''
      export PATH="/opt/homebrew/bin:$PATH"
      export HOMEBREW_PREFIX="/opt/homebrew"
    '';
  };

  homebrew = {
    enable = true;
    taps = [
      "FelixKratz/formulae"
    ];
    casks = [
    ];
    brews = [
      "FelixKratz/formulae/borders"
    ];
  };

  system.defaults = {
    NSGlobalDomain = {
      NSWindowShouldDragOnGesture = true;
    };
  };

  programs.fish.enable = true;
  programs.direnv.enable = true;
}
