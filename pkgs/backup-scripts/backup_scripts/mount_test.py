from __future__ import annotations

import subprocess
from pathlib import Path

import pytest

from backup_scripts import mount as mount_mod
from backup_scripts.mount import (
    DRIVE_NAME_PREFIX,
    InvalidDeviceTypeError,
    UnlockedDrive,
    parse_drives,
)


def _completed(stdout: bytes) -> subprocess.CompletedProcess[bytes]:
    return subprocess.CompletedProcess(args="", returncode=0, stdout=stdout)


def test_parse_drives_valid(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.setattr(mount_mod, "MOUNT_DIR", tmp_path / "mnt")
    monkeypatch.setattr(
        mount_mod, "shell", lambda *_a, **_k: _completed(b"/dev/sda1\n/dev/sdb1\n")
    )

    drives = parse_drives([Path("/dev/sda1")])
    assert len(drives) == 1
    d = drives[0]
    assert isinstance(d, UnlockedDrive)
    assert d.device == "/dev/sda1"
    assert d.name == f"{DRIVE_NAME_PREFIX}-sda1"
    assert d.mount == (tmp_path / "mnt") / f"{DRIVE_NAME_PREFIX}-sda1"
    # parse_drives ensures the mount directory exists.
    assert (tmp_path / "mnt").is_dir()


def test_parse_drives_rejects_non_luks(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.setattr(mount_mod, "MOUNT_DIR", tmp_path / "mnt")
    monkeypatch.setattr(mount_mod, "shell", lambda *_a, **_k: _completed(b"/dev/sda1\n"))

    with pytest.raises(InvalidDeviceTypeError):
        parse_drives([Path("/dev/sdX9")])


def test_parse_drives_multiple(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.setattr(mount_mod, "MOUNT_DIR", tmp_path / "mnt")
    monkeypatch.setattr(
        mount_mod, "shell", lambda *_a, **_k: _completed(b"/dev/sda1\n/dev/sdb1\n")
    )

    drives = parse_drives([Path("/dev/sda1"), Path("/dev/sdb1")])
    assert [d.name for d in drives] == [
        f"{DRIVE_NAME_PREFIX}-sda1",
        f"{DRIVE_NAME_PREFIX}-sdb1",
    ]
