{
  description = "nix home-manager configuration";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Non-nix inputs
    discord = {
      url = "https://dl.discordapp.net/apps/linux/0.0.19/discord-0.0.19.tar.gz";
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
    , flake-utils
    , discord
    , nvim-treesitter
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      makeHomeConfiguration = { host, nixDir, screen, username, chooseBundles }:
        let
          sys = { inherit host nixDir screen; };
          srcs = { inherit discord fish-plugin-wd fish-plugin-nix-env nvim-treesitter; };
          pkgs = import ./pkgs { inherit system nixpkgs srcs; };
          bundles = import ./home;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit sys srcs; };
          modules = chooseBundles bundles ++ [{
            programs.home-manager.enable = true;
            # Automatically set some environment variables that will ease usage of software 
            # installed with nix on non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc).
            targets.genericLinux.enable = true;
            # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
            nixpkgs.config.allowUnfreePredicate = (pkg: true);
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "22.11";
          }];
        };
    in
    {
      packages = {
        homeConfigurations = {
          splendor = makeHomeConfiguration {
            host = "splendor";
            nixDir = "/dots/nix";
            screen = "desktop";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.i3Bundle
              b.themeBundle
            ];
          };
          neptune = makeHomeConfiguration {
            host = "neptune";
            nixDir = "/dots/nix";
            screen = "laptop";
            username = "blissful";
            chooseBundles = b: [
              b.cliBundle
              b.devBundle
              b.guiBundle
              b.i3Bundle
              b.swayBundle
              b.themeBundle
            ];
          };
          sunset = makeHomeConfiguration {
            host = "sunset";
            nixDir = "/dots/nix";
            screen = "none";
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
