{ original, srcs }:

original.overrideAttrs (_: {
  src = srcs.discord-src;
})
