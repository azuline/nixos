"""
Unlock, mount, and unlock the encrypted drives.
"""

import logging
import shlex
from dataclasses import dataclass
from pathlib import Path

from src.common import shell

logger = logging.getLogger(__name__)


@dataclass
class UnlockedDrive:
    device: str
    name: str
    mount: Path


class InvalidDeviceTypeError(Exception):
    pass


def mount_drives(devices: list[Path]) -> list[UnlockedDrive]:
    """
    Takes in a list of crypto_LUKS devices and mounts them into directories inside of
    ~/tmp/encrypted-drives.
    """
    drives = parse_drives(devices)

    # Clean up in case a previous run failed.
    logger.info("Cleaning up any previous runs...")
    for d in drives:
        # Unmount the drive if it wasn't previously unmounted. Errors are OK.
        shell(f"sudo umount --quiet {shlex.quote(str(d.mount))}", check=False)
        # And if the drive is unlocked, lock it.
        result = shell(f"sudo cryptsetup status {shlex.quote(d.name)}", check=False, capture=True)
        if "is active." in result.stdout.decode():
            logger.info(f"Closed {d.device} from a previous run.")
            shell(f"sudo cryptsetup luksClose {shlex.quote(d.name)}")

    # Open and mount the drives.
    for d in drives:
        logger.info(f"Unlocking drive {d.device}...")
        shell(f"sudo cryptsetup luksOpen {shlex.quote(d.device)} {shlex.quote(d.name)}")
        logger.info(f"Mounting drive {d.device}...")
        d.mount.mkdir(exist_ok=True)
        shell(f"sudo mount /dev/mapper/{shlex.quote(d.name)} {shlex.quote(str(d.mount))}")

    return drives


def unmount_drives(devices: list[Path]) -> None:
    drives = parse_drives(devices)

    for d in drives:
        logger.info(f"Unmounting drive {d.device}...")
        shell(f"sudo umount {shlex.quote(str(d.mount))}")
        logger.info(f"Locking drive {d.device}...")
        shell(f"sudo cryptsetup luksClose {shlex.quote(d.name)}")


def parse_drives(devices: list[Path]) -> list[UnlockedDrive]:
    """Parse a list of devices into drives. Validate them along the way."""
    # Validate that the devices are of the type crypto_LUKS.
    result = shell("blkid | grep 'crypto_LUKS' | cut -d':' -f1", capture=True)
    invalid = [str(d) for d in devices if str(d) not in result.stdout.decode()]
    if invalid:
        raise InvalidDeviceTypeError(
            f"Invalid drives {', '.join(invalid)}: Drives must be devices of type crypto_LUKS."
        )

    # Prepare the mount directory. Create it if it's missing so that we don't
    # get errors later.
    mount_dir = Path.home() / "mnt" / "encrypted-drives"
    mount_dir.mkdir(parents=True, exist_ok=True)

    return [
        UnlockedDrive(device=str(d), name=f"enc-{d.name}", mount=mount_dir / f"enc-{d.name}")
        for d in devices
    ]
