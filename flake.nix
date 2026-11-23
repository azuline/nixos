{
  description = "blissful's /etc/nixos";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # Rolling unstable nixpkgs, updated frequently. If setting manually, pick a
    # commit built in Hydra: https://hydra.nixos.org/jobset/nixos/trunk-combined
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Stable channel for compatibility packages and server services.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    # Rose still requires llfuse, which was removed in 26.05.
    nixpkgs-rose.url = "github:nixos/nixpkgs/cd648d6ea62bc0ffba91e61fcfe5e33c1e2004b1";
    # Most up to date nixpkgs, for specific bug fixes.
    nixpkgs-latest.url = "github:nixos/nixpkgs/master";
    # Old nixpkgs.
    nixpkgs-old.url = "github:nixos/nixpkgs?rev=a7d87b7f9b63f97c43269fa902eb89851b379687";
    # For MacOS.
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flake sources.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    presage-src = {
      url = "github:azuline/presage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-cli-src = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pgmigrate-src = {
      url = "github:peterldowns/pgmigrate";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    rose-src = {
      url = "github:azuline/rose";
      inputs.nixpkgs.follows = "nixpkgs-rose";
    };
    opencode-src = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-flake sources.
    discord-src = {
      url = "https://dl.discordapp.net/apps/linux/0.0.129/discord-0.0.129.tar.gz";
      flake = false;
    };
    nnn-src = {
      url = "github:azuline/nnn";
      flake = false;
    };
    nsxiv-src = {
      url = "github:azuline/nsxiv";
      flake = false;
    };
    zathura-pdf-mupdf-src = {
      url = "github:azuline/zathura-pdf-mupdf";
      flake = false;
    };
    fish-plugin-wd = {
      url = "github:fischerling/plugin-wd";
      flake = false;
    };
    fish-plugin-nix-env = {
      url = "github:lilyball/nix-env.fish";
      flake = false;
    };
    plex-hama = {
      url = "github:ZeroQI/Hama.bundle";
      flake = false;
    };
    plex-ass = {
      url = "github:ZeroQI/Absolute-Series-Scanner";
      flake = false;
    };
    handy-src = {
      url = "https://github.com/cjpais/Handy/releases/download/v0.8.3/Handy_0.8.3_amd64.AppImage";
      flake = false;
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-rose,
      nixpkgs-latest,
      nixpkgs-old,
      nix-darwin,
      flake-utils,
      nix-search-cli-src,
      presage-src,
      pgmigrate-src,
      rose-src,
      opencode-src,
      # Non-Nix sources
      discord-src,
      nnn-src,
      nsxiv-src,
      zathura-pdf-mupdf-src,
      fish-plugin-wd,
      fish-plugin-nix-env,
      plex-hama,
      plex-ass,
      handy-src,
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-latest = import nixpkgs-latest {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-old = import nixpkgs-old {
          inherit system;
          config.allowUnfree = true;
        };
        srcs = {
          inherit
            discord-src
            nnn-src
            nsxiv-src
            fish-plugin-wd
            fish-plugin-nix-env
            zathura-pdf-mupdf-src
            handy-src
            ;
        };
        pins = {
          nix-search-cli = nix-search-cli-src.packages.${system}.nix-search;
          rose-py = rose-src.packages.${system}.rose-py;
          rose-cli = rose-src.packages.${system}.rose-cli;
          presage = presage-src.defaultPackage.${system};
          # Upstream's package still requires the removed Go 1.24 builder.
          pgmigrate = pkgs-stable.buildGoModule (finalAttrs: {
            pname = "pgmigrate";
            version = nixpkgs.lib.trim (builtins.readFile "${pgmigrate-src}/VERSION");
            src = "${pgmigrate-src}/cmd/pgmigrate";
            vendorHash = "sha256-UbgLpHOeSPtxZvia/IZbOotiENRFbg2wvExYmd0JL4o=";
            GOWORK = "off";
            ldflags = [
              "-X github.com/peterldowns/pgmigrate/cmd/pgmigrate/shared.Version=${finalAttrs.version}"
              "-X github.com/peterldowns/pgmigrate/cmd/pgmigrate/shared.Commit=${
                builtins.substring 0 7 pgmigrate-src.rev
              }"
            ];
            doCheck = false;
          });
          opencode = opencode-src.packages.${system}.default.overrideAttrs (old: {
            # Upstream's x86_64 Linux dependency hash is stale for this source pin.
            node_modules = old.node_modules.overrideAttrs (
              nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
                outputHash = "sha256-ORhRyEvo5KBziH7Z2tmyPmo3vuVfw5+HnA4CPPYHCug=";
              }
            );
          });
          zoom-us = pkgs-stable.zoom-us;
          # Plata still requires GTK 2, which unstable has removed.
          plata-theme = pkgs-stable.plata-theme;
          # Unstable's semgrep-core currently crashes in patchelf during fixup.
          semgrep = pkgs-stable.semgrep;
          # Keep the custom EPUB styles on the stable Zathura package.
          zathura = pkgs-stable.callPackage ./pkgs/zathura {
            inherit srcs;
            original = pkgs-stable.zathura;
          };
          chromium = pkgs-stable.chromium;
          signal-desktop = pkgs-latest.signal-desktop;
        }
        // nixpkgs.lib.optionalAttrs pkgs-latest.stdenv.hostPlatform.isLinux {
          # Use cached Linux builds for these packages.
          inherit (pkgs-latest) biome telegram-desktop zed-editor;
        };
        pkgs = import ./pkgs {
          # Keep the custom Python environment compatible with Rose and llfuse.
          inherit (nixpkgs-rose.legacyPackages.${system}) python313;
          inherit
            system
            nixpkgs
            srcs
            pins
            ;
        };
        makeHomeConfiguration =
          {
            # This enables per-host configurations, typically screen size differences.
            host,
            # Location of Nix directory.
            nixDir,
            # Whether we are connected to an external monitor (laptop only). The monitor name.
            monitor ? null,
            # Theme selection: "cool" or "warm"
            theme,
            # Username for home-manager configuration.
            username,
            # A function that takes post-parametrized bundles of packages and returns a subset.
            chooseBundles,
            # Custom per-host module code.
            custom ? { ... }: { },
          }:
          let
            sys = {
              inherit
                host
                nixDir
                monitor
                theme
                ;
            };
            bundles = import ./home;
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit sys srcs;
            };
            modules =
              chooseBundles bundles
              ++ [
                ./modules/colors.nix
                {
                  programs.home-manager.enable = true;
                  # Automatically set some environment variables that will ease usage
                  # of software installed with nix on non-NixOS linux (fixing local
                  # issues, settings XDG_DATA_DIRS, etc).
                  targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;
                  # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
                  nixpkgs.config.allowUnfreePredicate = (pkg: true);
                  home.username = "${username}";
                  home.homeDirectory =
                    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
                  home.stateVersion = "22.11";
                }
              ]
              ++ [ custom ];
          };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python
              ruff
              mypy
              python.pkgs.aiohttp
              python.pkgs.pyperclip
              python.pkgs.python-dotenv
            ];
          };
        };
        packages = {
          nixosConfigurations = {
            splendor = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                pin = {
                  inherit pkgs-stable;
                  inherit (pkgs) exif-mtime-sync;
                };
              };
              modules = [ ./os/splendor/configuration.nix ];
            };
            haiqin = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit pkgs-stable; };
              modules = [ ./os/haiqin/configuration.nix ];
            };
            neptune = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit pkgs-stable;
                pin = with pkgs; {
                  inherit
                    presage
                    plex-ass
                    plex-hama
                    ;
                };
              };
              modules = [ ./os/neptune/configuration.nix ];
            };
          };
          darwinConfigurations = {
            sunrise = nix-darwin.lib.darwinSystem {
              modules = [ ./os/sunrise/configuration.nix ];
            };
          };
          homeConfigurations = {
            splendor = makeHomeConfiguration {
              host = "splendor";
              nixDir = "/etc/nixos";
              username = "blissful";
              theme = "warm";
              chooseBundles = b: [
                b.cliBundle
                b.devBundle
                b.musicBundle
                b.guiBundle
                b.linuxGuiBundle
                b.personalMachineBundle
                b.i3Bundle
              ];
              custom =
                { pkgs, ... }:
                {
                  home.packages = with pkgs; [
                    backup-scripts
                    exif-mtime-sync
                    win-switch
                    splendor-change-audio
                  ];
                };
            };
            sunrise = makeHomeConfiguration {
              host = "sunrise";
              nixDir = "/etc/nixos";
              username = "mdong";
              theme = "cool";
              chooseBundles = b: [
                b.cliBundle
                b.devBundle
                b.musicBundle
                b.guiBundle
                b.macGuiBundle
              ];
            };
            haiqin = makeHomeConfiguration {
              host = "haiqin";
              nixDir = "/etc/nixos";
              username = "blissful";
              monitor = null;
              theme = "warm";
              chooseBundles = b: [
                b.cliBundle
                b.devBundle
                b.musicBundle
                b.guiBundle
                b.linuxGuiBundle
                b.personalMachineBundle
                b.i3Bundle
              ];
              custom =
                { pkgs, ... }:
                {
                  home.packages = with pkgs; [
                    monitor-switch
                    exif-mtime-sync
                    haiqin-change-audio
                  ];
                };
            };
            haiqin-monitor = makeHomeConfiguration {
              host = "haiqin";
              nixDir = "/etc/nixos";
              username = "blissful";
              monitor = "DP-2-1-5";
              theme = "warm";
              chooseBundles = b: [
                b.cliBundle
                b.devBundle
                b.musicBundle
                b.guiBundle
                b.linuxGuiBundle
                b.personalMachineBundle
                b.i3Bundle
              ];
              custom =
                { pkgs, ... }:
                {
                  home.packages = with pkgs; [
                    monitor-switch
                    exif-mtime-sync
                    haiqin-change-audio
                  ];
                };
            };
            neptune = makeHomeConfiguration {
              host = "neptune";
              nixDir = "/etc/nixos";
              username = "blissful";
              theme = "cool";
              chooseBundles = b: [
                b.cliBundle
                b.devBundle
                b.musicBundle
                b.guiBundle
                b.linuxGuiBundle
                b.personalMachineBundle
                b.i3Bundle
              ];
              custom =
                { ... }:
                {
                  imports = [ ./home/cdrama-rss ];
                };
            };
          };
        };
      }
    ));
}
