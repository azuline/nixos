{ pkgs }:

pkgs.python3.withPackages (ps: with ps; [
  flake8
  fonttools
  pid
  pip
  pipx
  requests
  shodan
  virtualenv
])
