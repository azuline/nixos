{ original, fetchurl, json-glib, xvfb-run, zathuraPkgs }:

# Zathura 0.5.4 has support for unequal page sizes.
let
  zathura_core = zathuraPkgs.zathura_core.overrideAttrs (prev: {
    version = "0.5.4";
    src = fetchurl {
      url = "https://pwmt.org/projects/zathura/download/zathura-0.5.4.tar.xz";
      sha256 = "sha256-owN/eqlNQJa/2XBp9i/83KnwZDHoZjVIwc1rlFxVbzI=";
    };
    nativeBuildInputs = prev.nativeBuildInputs ++ [ json-glib xvfb-run ];
    # Something is broken when xvfb runs in the sandbox test.
    doCheck = false;
  });
  zathura_djvu = zathuraPkgs.zathura_djvu.override { inherit zathura_core; };
  zathura_ps = zathuraPkgs.zathura_ps.override { inherit zathura_core; };
  zathura_cb = zathuraPkgs.zathura_cb.override { inherit zathura_core; };
  zathura_pdf_mupdf = zathuraPkgs.zathura_pdf_mupdf.override { inherit zathura_core; };
in
original.override {
  inherit zathura_core;
  plugins = [ zathura_djvu zathura_ps zathura_cb zathura_pdf_mupdf ];
}
