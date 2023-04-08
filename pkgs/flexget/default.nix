{ pkgs }:

pkgs.flexget.overrideAttrs (_: rec {
  # https://github.com/Flexget/Flexget/issues/3699
  version = "3.5.25";
  src = pkgs.fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = "refs/tags/v3.5.25";
    hash = "sha256-Xb33/wz85RjBpRkKD09hfDr6txoB1ksKphbjrVt0QWg=";
  };
})
