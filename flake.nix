{
  description = "nix home-manager configuration";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:nixos/nixpkgs;
    nixpkgs-peek-pin.url = github:nixos/nixpkgs?rev=b7d8c687782c8f9a1d425a7e486eb989654f6468;
    devenv = {
      url = github:cachix/devenv/latest;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-cli-src = {
      url = github:peterldowns/nix-search-cli;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    presage-src = {
      url = github:azuline/presage;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pgmigrate-src = {
      url = github:peterldowns/pgmigrate;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-nix inputs
    discord = {
      url = "https://dl.discordapp.net/apps/linux/0.0.21/discord-0.0.21.tar.gz";
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
    , nixpkgs-peek-pin
    , flake-utils
    , devenv
    , nix-search-cli-src
    , presage-src
    , pgmigrate-src
      # Non-Nix sources
    , discord
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      srcs = { inherit discord fish-plugin-wd fish-plugin-nix-env; };
      pins = {
        nix-search-cli = nix-search-cli-src.packages.${system}.nix-search;
        presage = presage-src.defaultPackage.${system};
        pgmigrate = pgmigrate-src.packages.${system}.pgmigrate;
        # Latest peek breaks with ffmpeg issue.
        peek = (import nixpkgs-peek-pin { inherit system; }).peek;
      };
      pkgs = import ./pkgs { inherit system nixpkgs srcs pins devenv; };
      makeHomeConfiguration =
        {
          # This enables per-host configurations, typically screen size differences.
          host
          # This is to block installation of packages that do not work on non-NixOS systems.
        , nixos
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
          sys = { inherit host nixos nixDir; };
          bundles = import ./home;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit sys srcs; };
          modules = chooseBundles bundles ++ [{
            # temporarily TODO
            manual.manpages.enable = false;

            programs.home-manager.enable = true;
            # Automatically set some environment variables that will ease usage of software 
            # installed with nix on non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc).
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
      packages = {
        nixosConfigurations = {
          haiqin = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./systems/haiqin/configuration.nix ];
          };
          zen = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./systems/zen/configuration.nix ];
          };
          splendor = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./systems/splendor/configuration.nix ];
          };
        };
        homeConfigurations = {
          splendor = makeHomeConfiguration {
            host = "splendor";
            nixDir = "/etc/nixos";
            nixos = true;
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.localBundle
              b.i3Bundle
              b.themeBundle
            ];
            packages = with pkgs; [
              win-switch
            ];
          };
          haiqin = makeHomeConfiguration {
            host = "haiqin";
            nixDir = "/etc/nixos";
            nixos = true;
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.localBundle
              b.i3Bundle
              b.themeBundle
            ];
          };
          zen = makeHomeConfiguration {
            host = "zen";
            nixDir = "/etc/nixos";
            nixos = false;
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
