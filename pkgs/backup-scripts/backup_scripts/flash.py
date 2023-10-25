"""
Execute a backup onto the encrypted flash drive.
"""

import logging
import shlex
import socket
from datetime import datetime
from pathlib import Path

from backup_scripts.common import shell
from backup_scripts.mount import mount_drives, unmount_drives

logger = logging.getLogger(__name__)


class BackupDirectoryAlreadyExistsError(Exception):
    pass


def copy_dir(src: Path, dst: Path) -> None:
    """Copy a directory w/ rsync, excluding syncthing directories."""
    dst.mkdir(parents=True, exist_ok=True)
    shell(
        "rsync -ah "
        "--exclude='.stversions/*' --exclude '.stfolder/*' --exclude '.syncthing*' "
        # The trailing slash here tells rync to copy the directory contents into the destination,
        # instead of copying the directory itself into the contents.
        f"{shlex.quote(str(src))}/ "
        f"{shlex.quote(str(dst))}"
    )


def backup_flash_drives(devices: list[Path]) -> None:
    drives = mount_drives(devices)

    logger.info("Opening documents...")
    shell("/home/blissful/documents/open.sh")
    for d in drives:
        date = datetime.today().strftime("%Y-%m-%d")
        logger.info(f"Creating backup for {date} in {d.device} ({d.name})...")

        target_dir = d.mount / date
        if target_dir.exists():
            raise BackupDirectoryAlreadyExistsError(
                f"Backup directory {date} already exists. Please remove it."
            )
        target_dir.mkdir()

        logger.info("Copying SSH keys...")
        copy_dir(Path.home() / ".ssh", target_dir / "ssh" / socket.gethostname())
        logger.info("Copying passwords...")
        copy_dir(Path.home() / ".password-store", target_dir / "pass")
        logger.info("Copying documents...")
        copy_dir(Path.home() / "documents" / "contents", target_dir / "documents")
        logger.info("Copying backups...")
        copy_dir(Path.home() / "backups", target_dir / "backups")

        # Update permissions to 400/500. I would use a umask, but copying files
        # apparently doesn't respect the umask and preserves the previous permissions.
        shell(rf'find {shlex.quote(str(target_dir))} -type f -exec chmod 400 "{{}}" \+')
        shell(rf'find {shlex.quote(str(target_dir))} -type d -exec chmod 500 "{{}}" \+')

        logger.info(f"Finished creating backup for {date} in {d.device} ({d.name}).")

    logger.info("Closing documents...")
    shell("/home/blissful/documents/close.sh")
    input("Backup completed. Press any key to close the drives...")

    unmount_drives()
