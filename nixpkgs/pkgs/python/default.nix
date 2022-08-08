{ pkgs, ... }:

let
  wrappedPython =
    pkgs.python3.withPackages
      (ps: with ps; [
        requests
        pip
        pipx
        shodan
        virtualenv
        pid
      ]);
in
{
  home.packages = [
    wrappedPython
  ];
}
