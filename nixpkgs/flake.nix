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
    }: (
      flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        modules = import ./modules.nix;
        extraSpecialArgs.src = {
          inherit discord fish-plugin-wd fish-plugin-nix-env;
        };
      in
      {
        packages.homeConfigurations = {
          splendor = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs // {
              host = "splendor";
              nixDir = "/dots/nixpkgs";
              screen = "desktop";
            };
            modules = [
              {
                programs.home-manager.enable = true;
                # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
                nixpkgs.config.allowUnfreePredicate = (pkg: true);
                home.stateVersion = "22.11";
                home.username = "blissful";
                home.homeDirectory = "/home/blissful";
              }
              modules.cliModule
              modules.devModule
              modules.guiModule
              modules.i3Module
              modules.themeModule
            ];
          };
          neptune = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs // {
              host = "neptune";
              nixDir = "/dots/nixpkgs";
              screen = "laptop";
            };
            modules = [
              {
                programs.home-manager.enable = true;
                nixpkgs.config.allowUnfreePredicate = (pkg: true);
                home.stateVersion = "22.11";
                home.username = "blissful";
                home.homeDirectory = "/home/blissful";
              }
              modules.cliModule
              modules.devModule
              modules.guiModule
              modules.i3Module
              modules.swayModule
              modules.themeModule
            ];
          };
          sunset = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs // {
              host = "sunset";
              nixDir = "/dots/nixpkgs";
              screen = "none";
            };
            modules = [
              {
                programs.home-manager.enable = true;
                nixpkgs.config.allowUnfreePredicate = (pkg: true);
                home.stateVersion = "22.11";
                home.username = "regalia";
                home.homeDirectory = "/home/regalia";
              }
              modules.cliModule
              modules.devModule
            ];
          };
        };
      }));
}
