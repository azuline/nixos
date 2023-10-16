"""
Execute a backup onto the Backblaze B2 cloud storage via Restic.
"""

import os
import subprocess

RESTIC_SCRIPT = """
source /etc/nixos/pkgs/backup-scripts/.env.restic

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
    "$HOME/.music-source" \
    "$HOME/wlop" \
    "$HOME/.password-store" \
    "$HOME/.gnupg/pubring.kbx" \
    "$HOME/.gnupg/private-keys-v1.d" \
    "$HOME/.ssh"
"""


def backup_backblaze() -> None:
    try:
        subprocess.run([os.environ["HOME"] + "/documents/open.sh"], check=True)
        subprocess.run(["bash", "-c", RESTIC_SCRIPT], check=True)
    finally:
        subprocess.run([os.environ["HOME"] + "/documents/close.sh"], check=True)
