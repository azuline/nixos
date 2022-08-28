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
    , fish-plugin-wd
    , fish-plugin-nix-env
    }: (flake-utils.lib.eachDefaultSystem (system:
    let
      makeConfig = { host, nixDir, screen, username, chooseModules }:
        let
          sys = { inherit host nixDir screen; };
          srcs = { inherit discord fish-plugin-wd fish-plugin-nix-env; };
          pkgs = import ./pkgs { inherit system nixpkgs sys srcs; };
          modules = import ./modules;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit sys srcs; };
          modules = chooseModules modules ++ [{
            programs.home-manager.enable = true;
            # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
            nixpkgs.config.allowUnfreePredicate = (pkg: true);
            home.stateVersion = "22.11";
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
          }];
        };
    in
    {
      packages = {
        homeConfigurations = {
          splendor = makeConfig {
            host = "splendor";
            nixDir = "/dots/nixpkgs";
            screen = "desktop";
            username = "blissful";
            chooseModules = modules: [
              modules.cliModule
              modules.devModule
              modules.guiModule
              modules.i3Module
              modules.themeModule
            ];
          };
          neptune = makeConfig {
            host = "neptune";
            nixDir = "/dots/nixpkgs";
            screen = "desktop";
            username = "blissful";
            chooseModules = modules: [
              modules.cliModule
              modules.devModule
              modules.guiModule
              modules.i3Module
              modules.swayModule
              modules.themeModule
            ];
          };
          sunset = makeConfig {
            host = "sunset";
            nixDir = "/dots/nixpkgs";
            screen = "none";
            username = "regalia";
            chooseModules = modules: [
              modules.cliModule
              modules.devModule
            ];
          };
        };
      };
    }));
}
