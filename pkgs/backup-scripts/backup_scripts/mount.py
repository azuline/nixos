"""
Unlock, mount, and unlock the encrypted drives.
"""

import logging
import re
import shlex
from dataclasses import dataclass
from pathlib import Path

from backup_scripts.common import shell

logger = logging.getLogger(__name__)

MOUNT_DIR = Path.home().resolve() / "mnt" / "encrypted-drives"
DRIVE_NAME_PREFIX = "backup-flash"


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
    unmount_drives()

    # Open and mount the drives.
    for d in drives:
        logger.info(f"Unlocking drive {d.device}...")
        shell(f"sudo cryptsetup luksOpen {shlex.quote(d.device)} {shlex.quote(d.name)}")
        logger.info(f"Mounting drive {d.device}...")
        d.mount.mkdir(exist_ok=True)
        shell(f"sudo mount /dev/mapper/{shlex.quote(d.name)} {shlex.quote(str(d.mount))}")

    return drives


def unmount_drives() -> None:
    """
    Unmounts everything mounted in the mount directory and then locks the crypto_LUKS devices
    matching the name scheme.
    """
    # First, unmount everything.
    regex = re.compile(r".+? on (\/.*?) type .+")
    result = shell("mount", capture=True)
    for line in result.stdout.decode().splitlines():
        m = regex.match(line)
        if not m:
            raise Exception(f"Failed to parse output of mount: {line=}")
        mountpoint = Path(m[1])
        if mountpoint.parent == MOUNT_DIR.resolve():
            logger.debug(f"UNMOUNTING: Matched mountpoint {mountpoint} with MOUNT_DIR.")
            shell(f"sudo umount {shlex.quote(str(mountpoint))}")
            mountpoint.rmdir()
        else:
            logger.debug(f"SKIPPING: Did not match mountpoint {mountpoint} with MOUNT_DIR.")

    # And then lock the devices.
    result = shell("sudo dmsetup ls --target crypt | awk '{ print $1 }'", capture=True)
    for line in result.stdout.decode().splitlines():
        device = line.strip()
        if device.startswith(DRIVE_NAME_PREFIX):
            logger.debug(f"CLOSING: Matched device {device} with DRIVE_NAME_PREFIX.")
            shell(f"sudo cryptsetup luksClose {shlex.quote(device)}")
        else:
            logger.debug(f"SKIPPING: Did not match device {device} with DRIVE_NAME_PREFIX.")


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
    MOUNT_DIR.mkdir(parents=True, exist_ok=True)

    return [
        UnlockedDrive(
            device=str(d),
            name=f"{DRIVE_NAME_PREFIX}-{d.name}",
            mount=MOUNT_DIR / f"{DRIVE_NAME_PREFIX}-{d.name}",
        )
        for d in devices
    ]
