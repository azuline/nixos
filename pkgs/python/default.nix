{ rose, python311 }:

python311.withPackages (ps: with ps; [
  # Python Tooling
  pip
  pipx
  virtualenv
  # Libraries
  aiohttp
  passlib
  pid
  requests
  # CLI Tools
  flake8
  fonttools
  rose
  shodan
  # Data Science
  graphviz
  jupyter
  matplotlib
  numpy
  torch
])
