from pathlib import Path

import aiohttp

from file_uploader.common import USER_AGENT, enforce_extensions, extract_from_json_response, read_credential


async def imgur_upload(session: aiohttp.ClientSession, filepath: Path) -> str:
    enforce_extensions(filepath, ["jpg", "jpeg", "png", "gif", "mp4", "webm", "mkv"])
    client_id = read_credential("IMGUR_CLIENT_ID")
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
        return await extract_from_json_response(resp, lambda d: d["data"]["link"])
