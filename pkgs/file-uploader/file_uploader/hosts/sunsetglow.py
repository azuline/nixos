from pathlib import Path

import aiohttp

from file_uploader.common import (
    USER_AGENT,
    extract_from_json_response,
    read_credential,
)


async def sunsetglow_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    token = read_credential("SUNSETGLOW_KEY")
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
        return await extract_from_json_response(resp, lambda d: d["image_url"])
