from pathlib import Path

import click

from src.backblaze import backup_backblaze
from src.flash import backup_flash_drives
from src.mount import mount_drives, unmount_drives


@click.group()
def cli() -> None:
    """Personal backup tool!"""


@cli.group()
def flash() -> None:
    """Work with the encrypted flash drives."""


# fmt: off
@flash.command()
@click.argument("devices", type=click.Path(path_type=Path), nargs=-1, required=True)
# fmt: on
def mount(devices: list[Path]) -> None:
    """Mount encrypted flash drives."""
    mount_drives(devices)


# fmt: off
@flash.command()
# fmt: on
def unmount() -> None:
    """Unmount encrypted flash drives."""
    unmount_drives()


# fmt: off
@flash.command()
@click.argument("devices", type=click.Path(path_type=Path), nargs=-1, required=True)
# fmt: on
def backup(devices: list[Path]) -> None:
    """Create a new backup on the encrypted flash drives."""
    backup_flash_drives(devices)


@cli.group()
def backblaze() -> None:
    """Work with the Backblaze B2 Restic repository."""


@backblaze.command()
def backup() -> None:
    """Create a new backup in Backblaze B2 with Restic."""
    backup_backblaze()


if __name__ == "__main__":
    cli()
