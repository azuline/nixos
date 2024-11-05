{ writeShellScriptBin, qpdf }:

writeShellScriptBin "decrypt-pdf" ''
  #!/usr/bin/env bash
  set -euo pipefail

  bookmarks_file=$(mktemp)
  ${qpdf}/bin/qpdf --decrypt "$1" "$bookmarks_file"
  mv "$bookmarks_file" "$1"
''
