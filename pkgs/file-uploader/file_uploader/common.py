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


def enforce_extensions(p: Path, extensions: list[str]) -> None:
    ext = p.suffix[1:]  # Trim the leading dot.
    if ext not in extensions:
        raise InvalidFiletypeError(f"This filehost does not support the extension {ext}.")


def read_credential(key: str) -> str:
    try:
        return os.environ[key]
    except KeyError as e:
        raise MissingCredentialsError(
            f"Missing credentials: Please set {key} in ~/.config/fileuploader/env."
        ) from e


async def extract_from_json_response(
    resp: aiohttp.ClientResponse,
    accessor: Callable[[Any], str],
) -> str:
    j = await resp.json()
    rv = accessor(j)
    assert isinstance(rv, str)
    return rv
