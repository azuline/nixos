"""
Execute a backup onto the Backblaze B2 cloud storage via Restic.
"""

import subprocess

RESTIC_SCRIPT = """
source /etc/nixos/pkgs/backup-scripts/.env.restic

"$HOME/documents/open.sh"
restic backup \
    --exclude '**/.git/**' \
    --exclude '**/.syncthing*' \
    --exclude '**/.stfolder/**' \
    --exclude '**/.stversions/**' \
    --exclude '**/.thumbnails/**' \
    --exclude '**/.direnv/**' \
    --exclude '**/.ruff_cache/**' \
    --exclude '**/.mypy_cache/**' \
    --exclude '**/.aux' \
    --exclude '**/.fls' \
    --exclude '**/.log' \
    --exclude '**/.fdb_latexmk' \
    --exclude '**/.out' \
    --exclude '**/.toc' \
    --exclude '**/.synctex*' \
    --exclude '**/.dvi' \
    --exclude '**/.4ct' \
    --exclude '**/.4tc' \
    --exclude '**/.idv' \
    --exclude '**/.lg' \
    --exclude '**/.tmp' \
    --exclude '**/.xref' \
    "$HOME/backups" \
    --exclude "$HOME/backups/signal-*" \
    --exclude "$HOME/backups/threema-*" \
    "$HOME/archive" \
    "$HOME/artbooks" \
    "$HOME/atelier" \
    "$HOME/books" \
    "$HOME/documents/contents" \
    "$HOME/images" \
    "$HOME/kpop" \
    "$HOME/manga" \
    "$HOME/music" \
    "$HOME/wlop" \
    "$HOME/.password-store" \
    "$HOME/.gnupg/pubring.kbx" \
    "$HOME/.gnupg/private-keys-v1.d" \
    "$HOME/.ssh"
"$HOME/documents/close.sh"
"""


def backup_backblaze() -> None:
    subprocess.run(["bash", "-c", RESTIC_SCRIPT], check=True)
