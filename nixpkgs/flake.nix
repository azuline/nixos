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
      in
      {
        defaultPackage = home-manager.defaultPackage.${system};
        packages = {
          homeConfigurations = {
            splendor = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./hosts/splendor.nix ];
            };
          };
        };
      }
    );
}
