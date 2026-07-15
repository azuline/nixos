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


class UploadError(Exception):
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


async def _raise_for_status(resp: aiohttp.ClientResponse) -> None:
    """Raise a descriptive error (including the response body) on a non-2xx status."""
    if resp.status >= 400:
        body = (await resp.text()).strip()
        raise UploadError(f"Upload failed with HTTP {resp.status} {resp.reason}: {body}")


async def _extract_from_json_response(
    resp: aiohttp.ClientResponse,
    accessor: Callable[[Any], str],
) -> str:
    await _raise_for_status(resp)
    j = await resp.json()
    try:
        rv = accessor(j)
    except (KeyError, IndexError, TypeError) as e:
        raise UploadError(f"Unexpected response from filehost: {j}") from e
    if not isinstance(rv, str):
        raise UploadError(f"Unexpected response from filehost: {j}")
    return rv


async def _read_text_response(resp: aiohttp.ClientResponse) -> str:
    """Read a filehost that returns the URL as plain text, validating success."""
    await _raise_for_status(resp)
    text = (await resp.text()).strip()
    # These hosts return the bare URL on success and an error message otherwise;
    # without this check a failed upload would be silently treated as a URL.
    if not text.startswith("http"):
        raise UploadError(f"Upload failed, filehost returned: {text}")
    return text


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
        return await _read_text_response(resp)


async def litterbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://litterbox.catbox.moe/resources/internals/api.php",
            data={"time": "24h", "reqtype": "fileupload", "fileToUpload": fp},
            headers={"User-Agent": USER_AGENT},
        )
        return await _read_text_response(resp)


async def ptpimg_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif"])
    apikey = _read_credential("PTPIMG_KEY")
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://ptpimg.me/upload.php",
            data={"api_key": apikey, "file-upload[0]": fp},
            headers={
                "referer": "https://ptpimg.me/index.php",
                "User-Agent": USER_AGENT,
                "Accept": "application/json",
            },
        )
        return await _extract_from_json_response(
            resp, lambda d: f"https://ptpimg.me/{d[0]['code']}.{d[0]['ext']}"
        )


HOSTS: dict[str, UploadFunction] = {
    "sunsetglow": sunsetglow_upload,
    "vgy": vgy_upload,
    "imgur": imgur_upload,
    "catbox": catbox_upload,
    "litterbox": litterbox_upload,
    "ptpimg": ptpimg_upload,
}
