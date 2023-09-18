{ pkgs }:

pkgs.python3.withPackages (ps: with ps; [
  flake8
  fonttools
  passlib
  pid
  pip
  pipx
  requests
  shodan
  virtualenv
])
