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
      (old: {
        # Keep the EPUB stylesheet with the current upstream plugin source.
        postPatch = (old.postPatch or "") + ''
          stylesheet=$(sed -n '/^  \/\/ Custom styles\./,/^  fz_set_user_css(/p' \
            ${srcs.zathura-pdf-mupdf-src}/zathura-pdf-mupdf/document.c)
          test -n "$stylesheet"
          substituteInPlace zathura-pdf-mupdf/document.c \
            --replace-fail '  /* open document */' "$stylesheet

          /* open document */"
        '';
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
