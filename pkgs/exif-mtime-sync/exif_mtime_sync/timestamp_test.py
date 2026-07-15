from exif_mtime_sync.__main__ import timestamp_eq


def test_identical_timestamps_are_equal() -> None:
    assert timestamp_eq("2020:01:02 03:04:05", "2020:01:02 03:04:05")


def test_different_timestamps_are_not_equal() -> None:
    assert not timestamp_eq("2020:01:02 03:04:05", "2020:01:02 03:04:06")


def test_timezone_offset_is_ignored() -> None:
    assert timestamp_eq("2020:01:02 03:04:05+09:00", "2020:01:02 03:04:05")
    assert timestamp_eq("2020:01:02 03:04:05-05:00", "2020:01:02 03:04:05+02:00")


def test_differing_base_with_same_offset_is_not_equal() -> None:
    assert not timestamp_eq("2020:01:02 03:04:05+09:00", "2020:01:02 03:04:06+09:00")


def test_empty_strings_are_equal() -> None:
    assert timestamp_eq("", "")
