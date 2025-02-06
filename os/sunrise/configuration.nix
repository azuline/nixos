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
      curl
      jankyborders
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
    brews = [
      "colima"
      "gnu-sed" # Installed as gsed, for nnn.
    ];
    casks = [
      "bazecor"
      "chatgpt"
      "cursor"
      "discord"
      "figma"
      "firefox"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "notion"
      "notion-calendar"
      "plex"
      "plexamp"
      "popsql"
      "raycast"
      "signal"
      "skim"
      "slack"
      "steam"
      "telegram"
      "whatsapp"
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
