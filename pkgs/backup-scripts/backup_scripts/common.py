import contextlib
import logging
import subprocess
from collections.abc import Iterator
from pathlib import Path
from typing import Any

logger = logging.getLogger(__name__)

DOCUMENTS_DIR = Path.home() / "documents"


def shell(
    cmd: str,
    *,
    check: bool = True,
    capture: bool = False,
) -> subprocess.CompletedProcess[Any]:
    logger.debug(f"Running command: `{cmd}`.")
    return subprocess.run(cmd, shell=True, check=check, capture_output=capture)


@contextlib.contextmanager
def open_documents() -> Iterator[None]:
    """Decrypt the documents directory for the duration of the block, re-encrypting after."""
    logger.info("Opening documents...")
    shell(str(DOCUMENTS_DIR / "open.sh"))
    try:
        yield
    finally:
        logger.info("Closing documents...")
        shell(str(DOCUMENTS_DIR / "close.sh"))
