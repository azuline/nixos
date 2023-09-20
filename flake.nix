{
  description = "nix home-manager configuration";

  inputs = {
    # Rolling unstable nixpkgs, updated frequently.
    nixpkgs.url = github:nixos/nixpkgs;
    # Pin a less frequently updated version of Nixpkgs for server services like
    # Nomad, Consul, etc.
    nixpkgs-stable.url = github:nixos/nixpkgs?rev=4c5f59b5982cc53ebc104a44d666cbd85cf56184;
    flake-utils.url = github:numtide/flake-utils;
    # Flake sources.
    devenv = {
      url = github:cachix/devenv/latest;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    presage-src = {
      url = github:azuline/presage;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-cli-src = {
      url = github:peterldowns/nix-search-cli;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pgmigrate-src = {
      url = github:peterldowns/pgmigrate;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-flake sources.
    discord = {
      url = "https://dl.discordapp.net/apps/linux/0.0.21/discord-0.0.21.tar.gz";
      flake = false;
    };
    nsxiv-src = {
      url = github:azuline/nsxiv;
      flake = false;
    };
    nnn-for-plugins = {
      url = github:jarun/nnn;
      flake = false;
    };
    fish-plugin-wd = {
      url = github:fischerling/plugin-wd;
      flake = false;
    };
    fish-plugin-nix-env = {
      url = github:lilyball/nix-env.fish;
      flake = false;
    };
  };

  outputs =
    { self
    , home-manager
    , nixpkgs
    , nixpkgs-stable
    , flake-utils
    , devenv
    , nix-search-cli-src
    , presage-src
    , pgmigrate-src
      # Non-Nix sources
    , discord
    , nsxiv-src
    , nnn-for-plugins
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      srcs = { inherit discord nsxiv-src nnn-for-plugins fish-plugin-wd fish-plugin-nix-env; };
      pins = {
        nix-search-cli = nix-search-cli-src.packages.${system}.nix-search;
        presage = presage-src.defaultPackage.${system};
        pgmigrate = pgmigrate-src.packages.${system}.pgmigrate;
      };
      pkgs = import ./pkgs { inherit system nixpkgs srcs pins devenv; };
      pkgs-stable = import nixpkgs-stable { inherit system; };
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
          # Additional one-off packages to add to a single host.
        , packages ? [ ]
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
            home.packages = packages;
          }];
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
            modules = [ ./systems/splendor/configuration.nix ];
          };
          haiqin = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./systems/haiqin/configuration.nix ];
          };
          zen = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit pkgs-stable; };
            modules = [ ./systems/zen/configuration.nix ];
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
            packages = with pkgs; [
              backup-scripts
              exif-mtime-sync
              xorg.xmodmap # Temporary while keyboard is broken.
            ];
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
          zen = makeHomeConfiguration {
            host = "zen";
            nixDir = "/etc/nixos";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
            ];
          };
        };
      };
    }));
}
