from backup_scripts.common import shell


def test_shell_runs_and_returns_completed_process() -> None:
    result = shell("true")
    assert result.returncode == 0


def test_shell_capture_returns_stdout() -> None:
    result = shell("printf 'hello'", capture=True)
    assert result.stdout == b"hello"


def test_shell_no_check_does_not_raise() -> None:
    result = shell("exit 3", check=False)
    assert result.returncode == 3
