{ config, openclaw-packages, ... }:
let
  secretsDir = "${config.home.homeDirectory}/.config/openclaw/.secrets";
in
{
  # Inject pre-built openclaw packages into pkgs so the module can find them.
  nixpkgs.overlays = [
    (
      _final: _prev:
      openclaw-packages
      // {
        openclawPackages = openclaw-packages // {
          withTools = _args: openclaw-packages;
        };
      }
    )
  ];

  programs.openclaw = {
    enable = true;
    # Use gateway-only package to avoid tool conflicts with existing dev toolchain.
    package = openclaw-packages.openclaw-gateway;
    documents = ./documents;

    # Disable bundled plugins that would add conflicting binaries.
    bundledPlugins = {
      summarize.enable = false;
      goplaces.enable = false;
    };

    config = {
      gateway = {
        mode = "local";
        auth.token = "file:${secretsDir}/gateway-token";
      };

      channels.telegram = {
        tokenFile = "${secretsDir}/telegram-bot-token";
        allowFrom = [ 970318657 ];
        groups."*".requireMention = true;
      };
    };
  };

  # Load ANTHROPIC_API_KEY at runtime from secrets (not baked into nix store).
  systemd.user.services.openclaw-gateway.Service.EnvironmentFile = "${secretsDir}/anthropic-env";
}
