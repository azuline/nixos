{ original, fetchFromGitHub, srcs }:

original.overrideAttrs (_: {
  src = srcs.nsxiv-src;
})
