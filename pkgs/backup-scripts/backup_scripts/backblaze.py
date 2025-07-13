"""
Execute a backup onto the Backblaze B2 cloud storage via Restic.
"""

import os
import subprocess

RESTIC_SCRIPT = """
source /etc/nixos/pkgs/backup-scripts/.env.restic

restic backup \
    --exclude '**/.syncthing*' \
    --exclude '**/.stfolder/**' \
    --exclude '**/.stversions/**' \
    --exclude '**/.thumbnails/**' \
    --exclude '**/.direnv/**' \
    --exclude '**/.ruff_cache/**' \
    --exclude '**/.mypy_cache/**' \
    --exclude '**/.cache/**' \
    --exclude '**/.toolchain/**' \
    --exclude '**/.next/**' \
    --exclude '**/__pycache__/**' \
    --exclude '**/node_modules/**' \
    --exclude '**/.o' \
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
    "$HOME/archive" \
    "$HOME/art" \
    "$HOME/artbooks" \
    "$HOME/atelier" \
    "$HOME/backgrounds" \
    "$HOME/backups" \
    "$HOME/books" \
    "$HOME/documents/contents" \
    "$HOME/fonts" \
    "$HOME/images" --exclude "$HOME/images/Camera" --exclude "$HOME/images/Screenshots" \
    "$HOME/kpop" \
    "$HOME/manga" \
    "$HOME/.music-source" \
    "$HOME/resume" \
    "$HOME/scripts" \
    "$HOME/studies" \
    "$HOME/.passwarbles" \
    "$HOME/.gnupg/pubring.kbx" \
    "$HOME/.gnupg/private-keys-v1.d" \
    "$HOME/.ssh"
"""  # noqa: E501


def backup_backblaze() -> None:
    try:
        subprocess.run([os.environ["HOME"] + "/documents/open.sh"], check=True)
        subprocess.run(["bash", "-c", RESTIC_SCRIPT], check=True)
    finally:
        subprocess.run([os.environ["HOME"] + "/documents/close.sh"], check=True)
