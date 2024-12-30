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
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "left";
      show-recents = false;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      NSWindowShouldDragOnGesture = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = true;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = true;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  programs.fish.enable = true;
  programs.direnv.enable = true;
}
