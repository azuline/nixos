{ rose, python313 }:

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
    # CLI Tools
    rose
    sh
    shodan
  ]
)
