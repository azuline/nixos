"""
Execute a backup onto the encrypted flash drive.
"""

import logging
import shlex
import shutil
import socket
from datetime import datetime
from pathlib import Path

from backup_scripts.common import shell
from backup_scripts.mount import mount_drives, unmount_drives

logger = logging.getLogger(__name__)


class BackupDirectoryAlreadyExistsError(Exception):
    pass


def backup_flash_drives(devices: list[Path]) -> None:
    drives = mount_drives(devices)

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
        shutil.copytree(Path.home() / ".ssh", target_dir / "ssh" / socket.gethostname())
        logger.info("Copying passwords...")
        shutil.copytree(Path.home() / ".password-store", target_dir / "pass")
        logger.info("Copying documents...")
        shutil.copytree(Path.home() / "documents", target_dir / "documents")
        logger.info("Copying backups...")
        shutil.copytree(Path.home() / "backups", target_dir / "backups")

        # Update permissions to 400/500. I would use a umask, but copying files
        # apparently doesn't respect the umask and preserves the previous permissions.
        shell(rf'find {shlex.quote(str(target_dir))} -type f -exec chmod 400 "{{}}" \+')
        shell(rf'find {shlex.quote(str(target_dir))} -type d -exec chmod 500 "{{}}" \+')

        logger.info(f"Finished creating backup for {date} in {d.device} ({d.name}).")

    input("Backup completed. Press any key to close the drives...")

    unmount_drives()
