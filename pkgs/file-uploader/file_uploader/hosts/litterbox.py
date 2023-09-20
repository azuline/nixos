from pathlib import Path

import aiohttp

from file_uploader.common import (
    USER_AGENT,
)


async def litterbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://litterbox.catbox.moe/resources/internals/api.php",
            data={"time": "24h", "reqtype": "fileupload", "fileToUpload": fp},
            headers={"User-Agent": USER_AGENT},
        )
        return await resp.text()
