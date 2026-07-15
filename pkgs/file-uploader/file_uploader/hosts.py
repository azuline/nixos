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


async def _upload_file(
    session: aiohttp.ClientSession,
    url: str,
    filepath: Path,
    *,
    file_field: str,
    data: dict[str, Any] | None = None,
    headers: dict[str, str] | None = None,
    accessor: Callable[[Any], str] | None = None,
) -> str:
    """POST a file to a filehost and return the resulting URL.

    The file is sent as multipart form data under ``file_field``, alongside any additional
    ``data`` fields. If ``accessor`` is provided, the response is parsed as JSON and the
    accessor extracts the URL; otherwise the raw response body is returned.
    """
    request_headers = {"User-Agent": USER_AGENT}
    if accessor is not None:
        request_headers["Accept"] = "application/json"
    if headers:
        request_headers.update(headers)

    with filepath.open("rb") as fp:
        resp = await session.post(
            url,
            data={**(data or {}), file_field: fp},
            headers=request_headers,
        )
        if accessor is None:
            return await resp.text()
        rv = accessor(await resp.json())
        assert isinstance(rv, str)
        return rv


# Uploaders


async def sunsetglow_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    token = _read_credential("SUNSETGLOW_KEY")
    return await _upload_file(
        session,
        "https://u.sunsetglow.net/upload",
        filepath,
        file_field="upload",
        headers={"Authorization": f"Token {token}"},
        accessor=lambda d: d["image_url"],
    )


async def vgy_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif"])
    userkey = _read_credential("VGY_KEY")
    return await _upload_file(
        session,
        "https://vgy.me/upload",
        filepath,
        file_field="file",
        data={"userkey": userkey},
        accessor=lambda d: d["image"],
    )


async def imgur_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif", "mp4", "webm", "mkv"])
    client_id = _read_credential("IMGUR_CLIENT_ID")
    return await _upload_file(
        session,
        "https://api.imgur.com/3/image",
        filepath,
        file_field="image",
        data={"album_id": "", "title": "", "description": ""},
        headers={"Authorization": f"Client-ID {client_id}"},
        accessor=lambda d: d["data"]["link"],
    )


async def catbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    return await _upload_file(
        session,
        "https://catbox.moe/user/api.php",
        filepath,
        file_field="fileToUpload",
        data={"reqtype": "fileupload"},
    )


async def litterbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    return await _upload_file(
        session,
        "https://litterbox.catbox.moe/resources/internals/api.php",
        filepath,
        file_field="fileToUpload",
        data={"time": "24h", "reqtype": "fileupload"},
    )


async def ptpimg_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    _enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif"])
    apikey = _read_credential("PTPIMG_KEY")
    return await _upload_file(
        session,
        "https://ptpimg.me/upload.php",
        filepath,
        file_field="file-upload[0]",
        data={"api_key": apikey},
        headers={"referer": "https://ptpimg.me/index.php"},
        accessor=lambda d: f"https://ptpimg.me/{d[0]['code']}.{d[0]['ext']}",
    )


HOSTS: dict[str, UploadFunction] = {
    "sunsetglow": sunsetglow_upload,
    "vgy": vgy_upload,
    "imgur": imgur_upload,
    "catbox": catbox_upload,
    "litterbox": litterbox_upload,
    "ptpimg": ptpimg_upload,
}
