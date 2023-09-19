#!/usr/bin/env python

import argparse
import logging
import re
import subprocess
import sys
from pathlib import Path
from shlex import quote

logger = logging.getLogger()
logger.setLevel(logging.INFO)
stream_formatter = logging.Formatter(
    "[%(asctime)s] %(levelname)s: %(message)s",
    datefmt="%H:%M:%S",
)
stream_handler = logging.StreamHandler(sys.stdout)
stream_handler.setFormatter(stream_formatter)
logger.addHandler(stream_handler)

parser = argparse.ArgumentParser(
    "exif-mtime-sync",
    description="""\
Sync an image's mtime and exif created at time to avoid accidentally losing
timestamps on file movements / backup restoration. By preserving timestamps in both
mtime and exif, we can preserve timestamps in our image archive.
""",
)
parser.add_argument("directory")
parser.add_argument("--dry-run", action="store_true")
parser.add_argument("--debug", action="store_true")


def timestamp_eq(a: str, b: str) -> bool:
    """Compare without the timezone offset."""
    a = re.sub(r"[-+].*$", "", a)
    b = re.sub(r"[-+].*$", "", b)
    return a == b


def main() -> None:
    args = parser.parse_args()
    if args.debug:
        logger.setLevel(logging.DEBUG)

    dryrun = args.dry_run
    directory = args.directory

    result = subprocess.run(
        f"fd -e jpg -e jpeg -e png . {quote(directory)} | xargs -d'\n' exiftool -filepath -FileModifyDate -DateTimeOriginal -createdate -T | sort",
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
    )
    files = [line.strip().split("\t") for line in result.stdout.decode().splitlines()]

    for row in files:
        filepath = row[0]
        mtime = row[1]
        datetimeoriginal = row[2]
        createdate = row[3]
        filename = Path(filepath).name

        # Construct the list of transformations and the log line as we go.
        #
        # Sometimes, we write "-FileModifyDate<FileModifyDate" because if we
        # don't, the mtime will be updated when the other transformations run.
        # We want the mtime to be in sync with the image's creation date.
        logline = f"{filename}:"
        writes: list[str] = []
        if datetimeoriginal != "-":
            if not timestamp_eq(datetimeoriginal, createdate):
                logline += " d>c"
                writes.append("-createdate<DateTimeOriginal")
            if not timestamp_eq(datetimeoriginal, mtime):
                logline += " d>m"
                writes.append("-FileModifyDate<DateTimeOriginal")
            elif writes:
                writes.append("-FileModifyDate<FileModifyDate")
        elif createdate != "-":
            logline += " c>d"
            writes.append("-DateTimeOriginal<createdate")
            if not timestamp_eq(createdate, mtime):
                logline += " c>m"
                writes.append("-FileModifyDate<createdate")
            else:
                writes.append("-FileModifyDate<FileModifyDate")
        else:
            logline += " m>d m>c"
            writes.extend(["-createdate<FileModifyDate", "-DateTimeOriginal<FileModifyDate", "-FileModifyDate<FileModifyDate"])

        # Print the log line to console.
        if not writes:
            logline += " no changes"
        logger.info(logline)
        logger.debug(f"Variables: {filepath=} {mtime=} {datetimeoriginal=} {createdate=}")

        # Dxecute the shell command.
        if writes:
            cmd = ["exiftool", "-overwrite_original", *writes, filepath]
            logger.debug(f"shell: {cmd}")
            if not dryrun:
                subprocess.run(cmd, check=True, stdout=subprocess.PIPE)


if __name__ == "__main__":
    main()
