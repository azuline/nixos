{
  description = "blissful's /etc/nixos";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # Rolling unstable nixpkgs, updated frequently. If setting manually, pick a
    # commit built in Hydra: https://hydra.nixos.org/jobset/nixos/trunk-combined
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Whatever pin makes my server happy... https://hydra.nixos.org/jobset/nixos/release-24.05
    nixpkgs-stable.url = "github:nixos/nixpkgs?rev=a7d87b7f9b63f97c43269fa902eb89851b379687";
    # Most up to date nixpkgs, for specific bug fixes.
    nixpkgs-latest.url = "github:nixos/nixpkgs/master";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-src = {
      url = "github:azuline/rose/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-flake sources.
    nnn-src = {
      url = "github:azuline/nnn";
      flake = false;
    };
    discord = {
      url = "https://dl.discordapp.net/apps/linux/0.0.33/discord-0.0.33.tar.gz";
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
  };

  outputs =
    { self
    , home-manager
    , nixpkgs
    , nixpkgs-stable
    , nixpkgs-latest
    , flake-utils
    , nix-search-cli-src
    , presage-src
    , pgmigrate-src
    , rose-src
      # Non-Nix sources
    , nnn-src
    , discord
    , nsxiv-src
    , zathura-pdf-mupdf-src
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
      pkgs-latest = import nixpkgs-latest { inherit system; config.allowUnfree = true; };
      srcs = { inherit discord nnn-src nsxiv-src fish-plugin-wd fish-plugin-nix-env zathura-pdf-mupdf-src; };
      pins = {
        nix-search-cli = nix-search-cli-src.packages.${system}.nix-search;
        rose = rose-src.packages.${system}.rose-py;
        rose-cli = rose-src.packages.${system}.rose-cli;
        presage = presage-src.defaultPackage.${system};
        pgmigrate = pgmigrate-src.packages.${system}.pgmigrate;
      };
      pkgs = import ./pkgs { inherit system nixpkgs srcs pins; };
      makeHomeConfiguration =
        {
          # This enables per-host configurations, typically screen size differences.
          host
          # Location of Nix directory.
        , nixDir
          # Whether we are connected to an external monitor (laptop only). The monitor name.
        , monitor ? null
          # Username for home-manager configuration.
        , username
          # A function that takes post-parametrized bundles of packages and returns a subset.
        , chooseBundles
          # Custom per-host module code.
        , custom ? { ... }: { }
        }:
        let
          sys = { inherit host nixDir monitor; };
          bundles = import ./home;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit sys srcs; };
          modules = chooseBundles bundles ++ [{
            programs.home-manager.enable = true;
            # Automatically set some environment variables that will ease usage
            # of software installed with nix on non-NixOS linux (fixing local
            # issues, settings XDG_DATA_DIRS, etc).
            targets.genericLinux.enable = true;
            # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
            nixpkgs.config.allowUnfreePredicate = (pkg: true);
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "22.11";
          }] ++ [ custom ];
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
              pin = { transmission_4 = pkgs.transmission_4; };
            };
            modules = [ ./os/splendor/configuration.nix ];
          };
          haiqin = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./os/haiqin/configuration.nix ];
          };
          neptune = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./os/neptune/configuration.nix ];
          };
          frieren = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              pin = { presage = pkgs.presage; };
            };
            modules = [ ./os/frieren/configuration.nix ];
          };
        };
        homeConfigurations = {
          splendor = makeHomeConfiguration {
            host = "splendor";
            nixDir = "/etc/nixos";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.personalMachineBundle
              b.i3Bundle
            ];
            custom = { pkgs, ... }: {
              imports = [ ./home/cdrama-rss ];
              home.packages = with pkgs; [
                backup-scripts
                exif-mtime-sync
                win-switch
                splendor-change-audio
              ];
            };
          };
          haiqin = makeHomeConfiguration {
            host = "haiqin";
            nixDir = "/etc/nixos";
            username = "blissful";
            monitor = null;
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.personalMachineBundle
              b.i3Bundle
            ];
            custom = { pkgs, ... }: {
              home.packages = with pkgs; [
                (monitor-switch.override { monitor = "HDMI-1"; })
                exif-mtime-sync
                haiqin-change-audio
              ];
            };
          };
          haiqin-monitor = makeHomeConfiguration {
            host = "haiqin";
            nixDir = "/etc/nixos";
            username = "blissful";
            monitor = "HDMI-1";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.personalMachineBundle
              b.i3Bundle
            ];
            custom = { pkgs, ... }: {
              home.packages = with pkgs; [
                (monitor-switch.override { monitor = "HDMI-1"; })
                exif-mtime-sync
                haiqin-change-audio
              ];
            };
          };
          neptune = makeHomeConfiguration {
            host = "neptune";
            nixDir = "/etc/nixos";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.guiBundle
              b.personalMachineBundle
              b.i3Bundle
            ];
          };
          frieren = makeHomeConfiguration {
            host = "frieren";
            nixDir = "/etc/nixos";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
            ];
          };
        };
      };
    }));
}
