{
  description = "blissful's /etc/nixos";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    # Rolling unstable nixpkgs, updated frequently. If setting manually, pick a
    # commit built in Hydra: https://hydra.nixos.org/jobset/nixos/trunk-combined
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # https://hydra.nixos.org/jobset/nixos/release-23.11
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
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
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-stable = import nixpkgs-stable { inherit system; };
      pkgs-latest = import nixpkgs-latest { inherit system; };
      srcs = { inherit discord nnn-src nsxiv-src fish-plugin-wd fish-plugin-nix-env; };
      pins = {
        nix-search-cli = nix-search-cli-src.packages.${system}.nix-search;
        rose = rose-src.packages.${system}.rose-py;
        rose-cli = rose-src.packages.${system}.rose-cli;
        presage = presage-src.defaultPackage.${system};
        pgmigrate = pgmigrate-src.packages.${system}.pgmigrate;
        puddletag = pkgs-latest.puddletag;
      };
      pkgs = import ./pkgs { inherit system nixpkgs srcs pins; };
      makeHomeConfiguration =
        {
          # This enables per-host configurations, typically screen size differences.
          host
          # Location of Nix directory.
        , nixDir
          # Username for home-manager configuration.
        , username
          # A function that takes post-parametrized bundles of packages and returns a subset.
        , chooseBundles
          # Custom per-host module code.
        , custom ? { ... }: { }
        }:
        let
          sys = { inherit host nixDir; };
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
              inherit pkgs-stable;
              presage-pin = pkgs.presage;
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
                xorg.xmodmap # Temporary while keyboard is broken.
                win-switch
              ];
            };
          };
          haiqin = makeHomeConfiguration {
            host = "haiqin";
            nixDir = "/etc/nixos";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.personalMachineBundle
              b.i3Bundle
            ];
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
