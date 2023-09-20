from pathlib import Path

import aiohttp

from file_uploader.common import (
    USER_AGENT,
)


async def catbox_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    with filepath.open("rb") as fp:
        resp = await session.post(
            "https://catbox.moe/user/api.php",
            data={"reqtype": "fileupload", "fileToUpload": fp},
            headers={"User-Agent": USER_AGENT},
        )
        return await resp.text()
