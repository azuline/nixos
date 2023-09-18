"""
Execute a backup onto the encrypted flash drive.
"""

import logging
import shlex
import shutil
import socket
import subprocess
import sys
from datetime import datetime
from pathlib import Path

logger = logging.getLogger()
logger.setLevel(logging.INFO)
stream_formatter = logging.Formatter(
    "[%(asctime)s] %(levelname)s: %(message)s",
    datefmt="%H:%M:%S",
)
stream_handler = logging.StreamHandler(sys.stdout)
stream_handler.setFormatter(stream_formatter)
logger.addHandler(stream_handler)


def shell(
    cmd: str,
    *,
    check: bool = True,
    capture: bool = False,
) -> subprocess.CompletedProcess:
    logger.debug(f"Running command: `{cmd}`.")
    return subprocess.run(cmd, shell=True, check=check, capture_output=capture)


# Read in the drives to back up to.
drives = sys.argv[1:]
if not drives:
    logger.error(
        "Arguments required: Pass in the path(s) to the encrypted flash drives."
    )
    exit(1)

# Validate that the drives are of the type crypto_LUKS.
result = shell("blkid | grep 'crypto_LUKS' | cut -d':' -f1", capture=True)
invalid = [d for d in drives if d not in result.stdout.decode()]
if invalid:
    logger.error(
        f"Invalid drives {', '.join(invalid)}: Drives must be of type crypto_LUKS."
    )
    exit(1)


# Utility function.
def make_unlocked_device_name(i: int) -> str:
    return f"enc-{i}"


# Open and mount the drives to ~/mnt/encrypted-drives.
mount_dir = Path.home() / "mnt" / "encrypted-drives"
mount_dir.mkdir(parents=True, exist_ok=True)


# Clean up in case a previous run failed.
logger.info("Cleaning up any previous runs...")
for i, d in enumerate(drives):
    unlocked_device_name = make_unlocked_device_name(i)
    # Unmount the drive if it wasn't previously unmounted. Errors are OK.
    shell(
        f"sudo umount --quiet {shlex.quote(str(mount_dir / unlocked_device_name))}",
        check=False,
    )
    # And if the drive is unlocked, lock it.
    result = shell(
        f"sudo cryptsetup status {unlocked_device_name}",
        check=False,
        capture=True,
    )
    if "is active." in result.stdout.decode():
        logger.info(f"Closed {d} ({unlocked_device_name}) from a previous run.")
        shell(f"sudo cryptsetup luksClose {unlocked_device_name}")

for i, d in enumerate(drives):
    unlocked_device_name = make_unlocked_device_name(i)
    logger.info(f"Unlocking drive {d} ({unlocked_device_name})...")
    shell(f"sudo cryptsetup luksOpen {d} {unlocked_device_name}")
    logger.info(f"Mounting drive {d}...")
    (mount_dir / unlocked_device_name).mkdir(exist_ok=True)
    shell(
        f"sudo mount /dev/mapper/{unlocked_device_name} "
        f"{shlex.quote(str(mount_dir / unlocked_device_name))}"
    )

# Back up directories.
for i, d in enumerate(drives):
    unlocked_device_name = make_unlocked_device_name(i)
    date = datetime.today().strftime("%Y-%m-%d")

    logger.info(f"Creating backup for {date} in {d} ({unlocked_device_name})...")

    target_dir = mount_dir / unlocked_device_name / date
    if target_dir.exists():
        logger.error(f"Backup directory {date} already exists. Aborting.")
        exit(1)
    target_dir.mkdir()

    logger.info("Copying SSH keys...")
    shutil.copytree(Path.home() / ".ssh", target_dir / "ssh" / socket.gethostname())
    logger.info("Copying passwords...")
    shutil.copytree(Path.home() / ".password-store", target_dir / "pass")
    logger.info("Copying documents...")
    shutil.copytree(Path.home() / "documents", target_dir / "documents")
    logger.info("Copying backups...")
    shutil.copytree(Path.home() / "backups", target_dir / "backups")

    # Update permissions to 600/700. I would use a umask, but copying files
    # apparently doesn't respect the umask and preserves the previous permissions.
    shell(rf'find {shlex.quote(str(target_dir))} -type f -exec chmod 600 "{{}}" \+')
    shell(rf'find {shlex.quote(str(target_dir))} -type d -exec chmod 700 "{{}}" \+')

    logger.info(f"Finished creating backup for {date} in {d} ({unlocked_device_name}).")

input("Backup completed. We will close the drives next. Press any key to continue...")

# Close the drives
for i, d in enumerate(drives):
    unlocked_device_name = make_unlocked_device_name(i)
    logger.info(f"Unmounting drive {d} ({unlocked_device_name})...")
    shell(f"sudo umount {mount_dir / unlocked_device_name}")
    logger.info(f"Locking drive {d}...")
    result = shell(f"sudo cryptsetup luksClose {unlocked_device_name}")
