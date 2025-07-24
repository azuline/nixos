{
  original,
  srcs,
  zathuraPkgs,
}:

let
  zathura_core = zathuraPkgs.zathura_core;
  zathura_djvu = zathuraPkgs.zathura_djvu.override { inherit zathura_core; };
  zathura_ps = zathuraPkgs.zathura_ps.override { inherit zathura_core; };
  zathura_cb = zathuraPkgs.zathura_cb.override { inherit zathura_core; };
  zathura_pdf_mupdf =
    (zathuraPkgs.zathura_pdf_mupdf.override { inherit zathura_core; }).overrideAttrs
      (_: {
        src = srcs.zathura-pdf-mupdf-src;
      });
in
original.override {
  inherit zathura_core;
  plugins = [
    zathura_djvu
    zathura_ps
    zathura_cb
    zathura_pdf_mupdf
  ];
}
