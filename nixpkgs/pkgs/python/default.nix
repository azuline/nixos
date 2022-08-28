{ pkgs }:

pkgs.python3.withPackages (ps: with ps; [
  flake8
  pid
  pip
  pipx
  requests
  shodan
  virtualenv
])
