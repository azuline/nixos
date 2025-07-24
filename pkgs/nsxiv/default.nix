{
  original,
  fetchFromGitHub,
  srcs,
}:

original.overrideAttrs (_: {
  src = srcs.nsxiv-src;
  # Add a shorthand alias `iv`.
  postInstall = ''
    ln -s $out/bin/nsxiv $out/bin/iv
  '';
})
