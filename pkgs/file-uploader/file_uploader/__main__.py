import argparse
import asyncio
import os
import os.path
from pathlib import Path

import aiohttp
import pyperclip
from dotenv import load_dotenv

from file_uploader.hosts import HOSTS, MissingCredentialsError, UploadFunction

# fmt: off
parser = argparse.ArgumentParser("fup", description="Upload a file to a filehost.")
parser.add_argument("file", type=Path, nargs=1, help="Path of file to upload")
parser.add_argument("--to", "-t", type=str, choices=HOSTS.keys(), default="sunsetglow", help="File host to upload to")  # noqa: E501
# fmt: on


async def coro(uploader: UploadFunction, file: Path) -> str:
    async with aiohttp.ClientSession() as session:
        try:
            return await uploader(session, file)
        except FileNotFoundError:
            print(f"{file} does not exist.")
            exit(1)


def main() -> None:
    env_path = Path(os.environ["HOME"]) / ".config" / "fileuploader" / "env"
    if not env_path.is_file():
        raise MissingCredentialsError(
            f"Credentials file not found. Please add environment variables to {env_path}. "
            "Refer to the source code to see the required environment variables",
        )
    load_dotenv(env_path)

    args = parser.parse_args()
    uploader = HOSTS[args.to]

    file_url = asyncio.run(coro(uploader, args.file[0]))
    pyperclip.copy(file_url)
    print(file_url)


if __name__ == "__main__":
    main()
