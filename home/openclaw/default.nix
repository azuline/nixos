{
  config,
  lib,
  openclaw-packages,
  ...
}:
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

    # Disable bundled plugins that would add conflicting binaries.
    bundledPlugins = {
      summarize.enable = false;
      goplaces.enable = false;
    };
  };

  # Don't let the openclaw module manage openclaw.json — we maintain it manually.
  home.file.".openclaw/openclaw.json".enable = false;
  # Also prevent the activation script from force-symlinking over our config.
  home.activation.openclawConfigFiles = lib.mkForce (lib.hm.dag.entryAfter [ "openclawDirs" ] "");

  # Load ANTHROPIC_API_KEY at runtime from secrets (not baked into nix store).
  systemd.user.services.openclaw-gateway.Service.EnvironmentFile = "${secretsDir}/anthropic-env";
}
