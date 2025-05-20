{ original, srcs }:

original.overrideAttrs (_: {
  src = srcs.i3wsr-src;
})
