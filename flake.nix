{
  description = "nix home-manager configuration";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    # A somewhat stable and more infrequently updated nixpkgs version.
    nixpkgs.url = github:nixos/nixpkgs?rev=b7d8c687782c8f9a1d425a7e486eb989654f6468;
    # Latest nixpkgs version that we pull specific packages from.
    nixpkgs-latest.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix = {
      url = github:DavHau/mach-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-nix inputs
    discord = {
      url = "https://dl.discordapp.net/apps/linux/0.0.21/discord-0.0.21.tar.gz";
      flake = false;
    };
    nvim-treesitter = {
      url = github:nvim-treesitter/nvim-treesitter;
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
    , nixpkgs-latest
    , flake-utils
    , mach-nix
    , discord
    , nvim-treesitter
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      srcs = { inherit discord fish-plugin-wd fish-plugin-nix-env nvim-treesitter; };
      pins = {
        signal-desktop = (import nixpkgs-latest { inherit system; }).signal-desktop;
      };
      pkgs = import ./pkgs { inherit system nixpkgs srcs pins; };
      makeHomeConfiguration =
        {
          # This enables per-host configurations, typically screen size differences.
          host
          # This is to block installation of GL-dependent packages on non-NixOS systems.
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
            specialArgs = { inherit pkgs; };
            modules = [ ./systems/haiqin/configuration.nix ];
          };
        };
        homeConfigurations = {
          splendor = makeHomeConfiguration {
            host = "splendor";
            nixDir = "/etc/nixos";
            nixos = false;
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
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
              b.i3Bundle
              b.themeBundle
            ];
          };
          sunset = makeHomeConfiguration {
            host = "sunset";
            nixDir = "/etc/nixos";
            nixos = false;
            username = "regalia";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
            ];
          };
        };
      };
    }));
}
