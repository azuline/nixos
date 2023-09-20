from pathlib import Path

import aiohttp

from file_uploader.common import (
    USER_AGENT,
    enforce_extensions,
    extract_from_json_response,
    read_credential,
)


async def vgy_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif"])
    userkey = read_credential("VGY_KEY")
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://vgy.me/upload",
            data={"userkey": userkey, "file": fp},
            headers={
                "User-Agent": USER_AGENT,
                "Accept": "application/json",
            },
        )
        return await extract_from_json_response(resp, lambda d: d["image"])
