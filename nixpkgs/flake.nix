{
  description = "nix home-manager configuration";

  inputs = {
    flake-utils = {
      url = github:numtide/flake-utils;
    };
    nixpkgs = {
      url = github:nixos/nixpkgs/nixos-unstable;
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        modules = import ./pkgs;
      in
      {
        defaultPackage = home-manager.defaultPackage.${system};
        packages = {
          homeConfigurations = {
            splendor = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                screen = "desktop";
              };
              modules = [
                {
                  programs.home-manager.enable = true;
                  # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
                  nixpkgs.config.allowUnfreePredicate = (pkg: true);
                  home = {
                    username = "blissful";
                    homeDirectory = "/home/blissful";
                    stateVersion = "21.05";
                  };
                }
                modules.cliModule
                modules.devModule
                modules.envModule
                modules.guiModule
                modules.i3Module
                modules.themeModule
              ];
            };
            neptune = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                screen = "laptop";
              };
              modules = [
                {
                  programs.home-manager.enable = true;
                  # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
                  nixpkgs.config.allowUnfreePredicate = (pkg: true);
                  home = {
                    username = "blissful";
                    homeDirectory = "/home/blissful";
                    stateVersion = "21.05";
                  };
                }
                modules.cliModule
                modules.devModule
                modules.envModule
                modules.guiModule
                modules.i3Module
                modules.swayModule
                modules.themeModule
              ];
            };
            sunset = home-manager.lib.homeManagerConfiguration
              {
                inherit pkgs;
                modules = [
                  {
                    programs.home-manager.enable = true;
                    # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
                    nixpkgs.config.allowUnfreePredicate = (pkg: true);
                    home = {
                      username = "regalia";
                      homeDirectory = "/home/regalia";
                      stateVersion = "21.05";
                    };
                  }
                  modules.cliModule
                  modules.devModule
                ];
              };
          };
        };
      }
    );
}
