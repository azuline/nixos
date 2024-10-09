{ fetchFromGitHub, original }:

original.overrideAttrs (old: {
  version = "4.0.5";
  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    rev = "4.0.5";
    hash = "sha256-gd1LGAhMuSyC/19wxkoE2mqVozjGPfupIPGojKY0Hn4=";
    fetchSubmodules = true;
  };
})
