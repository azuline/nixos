{ python311, broken-pipx }:

python311.withPackages (ps: with ps; [
  aiohttp
  flake8
  fonttools
  passlib
  pid
  pip
  broken-pipx
  requests
  shodan
  virtualenv
])
