{ rose-py, python313 }:

python313.withPackages (
  ps: with ps; [
    # Python Tooling
    pip
    pipx
    virtualenv
    # Libraries
    aiohttp
    passlib
    pid
    rose-py
    # CLI Tools
    sh
    shodan
  ]
)
