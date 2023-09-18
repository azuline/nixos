{ python311 }:

python311.withPackages (ps: with ps; [
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
