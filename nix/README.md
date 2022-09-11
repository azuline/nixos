These are my Nix configurations across my machines.

- `pkgs` defines a `nixpkgs` with custom packages and overlays applied. The
  rest of my configurations use `pkgs`.
- `home` contains home-manager configurations.
- `system` contains configurations for machines on NixOS.
