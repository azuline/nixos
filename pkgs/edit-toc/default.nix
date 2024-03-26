{ writeShellScriptBin, pdftk }:

writeShellScriptBin "edit-toc" ''
  #!/usr/bin/env bash
  set -euo pipefail

  bookmarks_file=$(mktemp)
  ${pdftk}/bin/pdftk "$1" data_dump output "$bookmarks_file"
  "$EDITOR" "$bookmarks_file"
  modified_pdf_file=$(mktemp)
  ${pdftk}/bin/pdftk "$1" update_info "$bookmarks_file" output "$modified_pdf_file"
  mv "$modified_pdf_file" "$1"
''
