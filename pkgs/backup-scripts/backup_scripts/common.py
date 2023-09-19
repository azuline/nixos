import logging
import subprocess
from typing import Any

logger = logging.getLogger(__name__)


def shell(
    cmd: str,
    *,
    check: bool = True,
    capture: bool = False,
) -> subprocess.CompletedProcess[Any]:
    logger.debug(f"Running command: `{cmd}`.")
    return subprocess.run(cmd, shell=True, check=check, capture_output=capture)
