import os
from collections.abc import Callable, Coroutine
from pathlib import Path
from typing import Any

import aiohttp

USER_AGENT = "file uploader tool"

UploadFunction = Callable[[aiohttp.ClientSession, Path], Coroutine[None, None, str]]


class MissingCredentialsError(Exception):
    pass


class InvalidFiletypeError(Exception):
    pass


# Useful utilities


def _enforce_extensions(p: Path, extensions: list[str]) -> None:
    ext = p.suffix[1:]  # Trim the leading dot.
    if ext not in extensions:
        raise InvalidFiletypeError(f"This filehost does not support the extension {ext}.")


def _read_credential(key: str) -> str:
    try:
        return os.environ[key]
    except KeyError as e:
        raise MissingCredentialsError(
            f"Missing credentials: Please set {key} in ~/.config/fileuploader/env."
        ) from e


async def _extract_from_json_response(
    resp: aiohttp.ClientResponse,
    accessor: Callable[[Any], str],
) -> str:
    j = await resp.json()
    rv = accessor(j)
    assert isinstance(rv, str)
    return rv


# Uploaders


async def sunsetglow_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    token = _read_credential("SUNSETGLOW_KEY")
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://u.sunsetglow.net/upload",
            data={"upload": fp},
            headers={
                "User-Agent": USER_AGENT,
                "Accept": "application/json",
                "Authorization": f"Token {token}",
            },
        )
        return await _extract_from_json_response(resp, lambda d: d["image_url"])


async def vgy_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif"])
    userkey = _read_credential("VGY_KEY")
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://vgy.me/upload",
            data={"userkey": userkey, "file": fp},
            headers={
                "User-Agent": USER_AGENT,
                "Accept": "application/json",
            },
        )
        return await _extract_from_json_response(resp, lambda d: d["image"])


async def imgur_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif", "mp4", "webm", "mkv"])
    client_id = _read_credential("IMGUR_CLIENT_ID")
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://api.imgur.com/3/image",
            data={"album_id": "", "title": "", "description": "", "image": fp},
            headers={
                "User-Agent": USER_AGENT,
                "Accept": "application/json",
                "Authorization": f"Client-ID {client_id}",
            },
        )
        return await _extract_from_json_response(resp, lambda d: d["data"]["link"])


async def catbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://catbox.moe/user/api.php",
            data={"reqtype": "fileupload", "fileToUpload": fp},
            headers={"User-Agent": USER_AGENT},
        )
        return await resp.text()


async def litterbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://litterbox.catbox.moe/resources/internals/api.php",
            data={"time": "24h", "reqtype": "fileupload", "fileToUpload": fp},
            headers={"User-Agent": USER_AGENT},
        )
        return await resp.text()


HOSTS: dict[str, UploadFunction] = {
    "sunsetglow": sunsetglow_upload,
    "vgy": vgy_upload,
    "imgur": imgur_upload,
    "catbox": catbox_upload,
    "litterbox": litterbox_upload,
}
