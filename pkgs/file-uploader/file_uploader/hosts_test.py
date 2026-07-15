from __future__ import annotations

import asyncio
from pathlib import Path
from typing import Any

import pytest

from file_uploader.hosts import (
    HOSTS,
    InvalidFiletypeError,
    MissingCredentialsError,
    _enforce_extensions,
    _extract_from_json_response,
    _read_credential,
    catbox_upload,
    imgur_upload,
    litterbox_upload,
    ptpimg_upload,
    sunsetglow_upload,
    vgy_upload,
)


class FakeResponse:
    def __init__(self, *, json_body: Any = None, text_body: str = "") -> None:
        self._json_body = json_body
        self._text_body = text_body

    async def json(self) -> Any:
        return self._json_body

    async def text(self) -> str:
        return self._text_body


class FakeSession:
    """Records the arguments of the last post() call and returns a canned response."""

    def __init__(self, response: FakeResponse) -> None:
        self._response = response
        self.url: str | None = None
        self.data: dict[str, Any] | None = None
        self.headers: dict[str, str] | None = None

    async def post(self, url: str, *, data: Any = None, headers: Any = None) -> FakeResponse:
        self.url = url
        self.data = data
        self.headers = headers
        return self._response


def _run(coro: Any) -> Any:
    return asyncio.run(coro)


def test_enforce_extensions_accepts_allowed() -> None:
    _enforce_extensions(Path("photo.jpg"), ["jpg", "png"])


def test_enforce_extensions_rejects_disallowed() -> None:
    with pytest.raises(InvalidFiletypeError):
        _enforce_extensions(Path("movie.mp4"), ["jpg", "png"])


def test_enforce_extensions_is_case_sensitive() -> None:
    # The check compares the raw suffix, so uppercase extensions are rejected.
    with pytest.raises(InvalidFiletypeError):
        _enforce_extensions(Path("photo.JPG"), ["jpg"])


def test_read_credential_present(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("SOME_KEY", "secret-value")
    assert _read_credential("SOME_KEY") == "secret-value"


def test_read_credential_missing(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv("DEFINITELY_MISSING_KEY", raising=False)
    with pytest.raises(MissingCredentialsError):
        _read_credential("DEFINITELY_MISSING_KEY")


def test_extract_from_json_response_accessor() -> None:
    resp = FakeResponse(json_body={"image_url": "https://example.com/x.png"})
    result = _run(_extract_from_json_response(resp, lambda d: d["image_url"]))
    assert result == "https://example.com/x.png"


def test_extract_from_json_response_non_string_fails() -> None:
    resp = FakeResponse(json_body={"n": 123})
    with pytest.raises(AssertionError):
        _run(_extract_from_json_response(resp, lambda d: d["n"]))


def test_hosts_registry_keys() -> None:
    assert set(HOSTS) == {"sunsetglow", "vgy", "imgur", "catbox", "litterbox", "ptpimg"}
    assert HOSTS["sunsetglow"] is sunsetglow_upload
    assert HOSTS["imgur"] is imgur_upload


def test_sunsetglow_upload(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("SUNSETGLOW_KEY", "tok")
    f = tmp_path / "a.png"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(json_body={"image_url": "https://sg/x"}))
    url = _run(sunsetglow_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://sg/x"
    assert session.url == "https://u.sunsetglow.net/upload"
    assert session.headers is not None
    assert session.headers["Authorization"] == "Token tok"


def test_vgy_upload_rejects_bad_extension(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("VGY_KEY", "tok")
    f = tmp_path / "a.mp4"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(json_body={"image": "x"}))
    with pytest.raises(InvalidFiletypeError):
        _run(vgy_upload(session, f))  # type: ignore[arg-type]


def test_ptpimg_upload_builds_url(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("PTPIMG_KEY", "tok")
    f = tmp_path / "a.png"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(json_body=[{"code": "abc", "ext": "png"}]))
    url = _run(ptpimg_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://ptpimg.me/abc.png"


def test_vgy_upload(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("VGY_KEY", "tok")
    f = tmp_path / "a.jpg"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(json_body={"image": "https://vgy/x"}))
    url = _run(vgy_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://vgy/x"
    assert session.url == "https://vgy.me/upload"
    assert session.data is not None
    assert session.data["userkey"] == "tok"


def test_imgur_upload(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("IMGUR_CLIENT_ID", "cid")
    f = tmp_path / "a.png"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(json_body={"data": {"link": "https://imgur/x"}}))
    url = _run(imgur_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://imgur/x"
    assert session.headers is not None
    assert session.headers["Authorization"] == "Client-ID cid"


def test_litterbox_upload_returns_text(tmp_path: Path) -> None:
    f = tmp_path / "a.bin"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(text_body="https://litterbox/x"))
    url = _run(litterbox_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://litterbox/x"
    assert session.url == "https://litterbox.catbox.moe/resources/internals/api.php"
    assert session.data is not None
    assert session.data["time"] == "24h"


def test_catbox_upload_returns_text(tmp_path: Path) -> None:
    f = tmp_path / "a.bin"
    f.write_bytes(b"data")
    session = FakeSession(FakeResponse(text_body="https://catbox.moe/x"))
    url = _run(catbox_upload(session, f))  # type: ignore[arg-type]
    assert url == "https://catbox.moe/x"
    assert session.url == "https://catbox.moe/user/api.php"
