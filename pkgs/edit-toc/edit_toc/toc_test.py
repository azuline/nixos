from __future__ import annotations

from edit_toc.__main__ import (
    Bookmark,
    bookmarks_to_pdftk_format,
    parse_from_editable,
    parse_from_pdftk,
    replace_bookmarks_in_pdftk,
)


def _flatten(bookmarks: list[Bookmark]) -> list[Bookmark]:
    out: list[Bookmark] = []
    for b in bookmarks:
        out.append(b)
        out.extend(_flatten(b.children))
    return out


def _pdftk(*entries: tuple[str, int, int]) -> str:
    """Build a minimal pdftk data_dump body from (title, level, pageno) entries."""
    lines = []
    for title, level, pageno in entries:
        lines += [
            "BookmarkBegin",
            f"BookmarkTitle: {title}",
            f"BookmarkLevel: {level}",
            f"BookmarkPageNumber: {pageno}",
        ]
    return "\n".join(lines)


def test_to_user_format_single() -> None:
    bm = Bookmark(title="Intro", pageno=1, level=1, children=[])
    assert bm.to_user_format() == "1 Intro"


def test_to_user_format_nested_indentation() -> None:
    child = Bookmark(title="Child", pageno=2, level=2, children=[])
    parent = Bookmark(title="Parent", pageno=1, level=1, children=[child])
    assert parent.to_user_format() == "1 Parent\n 2 Child"


def test_to_user_format_escapes_newlines() -> None:
    bm = Bookmark(title="Line1\nLine2", pageno=3, level=1, children=[])
    assert bm.to_user_format() == "3 Line1\\nLine2"


def test_to_user_format_custom_indent_level() -> None:
    bm = Bookmark(title="Deep", pageno=5, level=1, children=[])
    assert bm.to_user_format(indent_level=3) == "   5 Deep"


def test_parse_from_pdftk_flat() -> None:
    content = _pdftk(("Chapter 1", 1, 1), ("Chapter 2", 1, 10))
    bookmarks = parse_from_pdftk(content)
    assert len(bookmarks) == 2
    assert bookmarks[0].title == "Chapter 1"
    assert bookmarks[0].pageno == 1
    assert bookmarks[0].level == 1
    assert bookmarks[0].children == []
    assert bookmarks[1].title == "Chapter 2"
    assert bookmarks[1].pageno == 10


def test_parse_from_pdftk_nesting() -> None:
    content = _pdftk(
        ("Chapter 1", 1, 1),
        ("Section 1.1", 2, 2),
        ("Section 1.2", 2, 4),
        ("Chapter 2", 1, 8),
    )
    bookmarks = parse_from_pdftk(content)
    assert len(bookmarks) == 2
    ch1, ch2 = bookmarks
    assert [c.title for c in ch1.children] == ["Section 1.1", "Section 1.2"]
    assert ch2.children == []


def test_parse_from_pdftk_deep_then_shallow() -> None:
    content = _pdftk(
        ("A", 1, 1),
        ("A.1", 2, 2),
        ("A.1.a", 3, 3),
        ("B", 1, 5),
    )
    bookmarks = parse_from_pdftk(content)
    assert len(bookmarks) == 2
    a, b = bookmarks
    assert a.children[0].title == "A.1"
    assert a.children[0].children[0].title == "A.1.a"
    assert b.children == []


def test_parse_from_pdftk_ignores_surrounding_metadata() -> None:
    content = (
        "InfoBegin\n"
        "InfoKey: Title\n"
        "NumberOfPages: 42\n"
        + _pdftk(("Only", 1, 7))
        + "\nPageMediaBegin\nPageMediaNumber: 1\n"
    )
    bookmarks = parse_from_pdftk(content)
    assert len(bookmarks) == 1
    assert bookmarks[0].title == "Only"
    assert bookmarks[0].pageno == 7


def test_parse_from_editable_flat() -> None:
    bookmarks = parse_from_editable("1 Chapter 1\n10 Chapter 2")
    assert [b.title for b in bookmarks] == ["Chapter 1", "Chapter 2"]
    assert [b.pageno for b in bookmarks] == [1, 10]
    assert all(b.level == 1 for b in bookmarks)


def test_parse_from_editable_level_from_indentation() -> None:
    # `level` is stored as (leading spaces + 1), matching pdftk's 1-based levels.
    text = "1 Chapter 1\n 2 Section 1.1\n  3 Sub 1.1.1"
    bookmarks = parse_from_editable(text)
    levels = [b.level for b in _flatten(bookmarks)]
    assert levels == [1, 2, 3]


def test_parse_from_editable_nesting() -> None:
    # A child nests under a parent when its indentation is deeper by >= 2 spaces.
    text = "1 Chapter 1\n  3 Section 1.1\n  5 Section 1.2\n8 Chapter 2"
    bookmarks = parse_from_editable(text)
    assert len(bookmarks) == 2
    ch1, ch2 = bookmarks
    assert [c.title for c in ch1.children] == ["Section 1.1", "Section 1.2"]
    assert ch2.children == []


def test_parse_from_editable_unescapes_newlines() -> None:
    bookmarks = parse_from_editable("3 Line1\\nLine2")
    assert bookmarks[0].title == "Line1\nLine2"


def test_parse_from_editable_skips_blank_lines() -> None:
    bookmarks = parse_from_editable("\n1 A\n\n  \n2 B\n")
    assert [b.title for b in bookmarks] == ["A", "B"]


def test_bookmarks_to_pdftk_format_flat() -> None:
    bms = [Bookmark(title="A", pageno=1, level=1, children=[])]
    assert bookmarks_to_pdftk_format(bms) == (
        "BookmarkBegin\nBookmarkTitle: A\nBookmarkLevel: 1\nBookmarkPageNumber: 1"
    )


def test_bookmarks_to_pdftk_format_nested_depth_first() -> None:
    child = Bookmark(title="A.1", pageno=2, level=2, children=[])
    parent = Bookmark(title="A", pageno=1, level=1, children=[child])
    out = bookmarks_to_pdftk_format([parent])
    assert out.index("BookmarkTitle: A") < out.index("BookmarkTitle: A.1")
    assert "BookmarkLevel: 2" in out


def test_roundtrip_pdftk_to_editable_to_pdftk() -> None:
    original = _pdftk(
        ("Chapter 1", 1, 1),
        ("Section 1.1", 2, 2),
        ("Chapter 2", 1, 8),
    )
    parsed = parse_from_pdftk(original)
    user = "\n".join(b.to_user_format() for b in parsed)
    reparsed = parse_from_editable(user)
    assert bookmarks_to_pdftk_format(reparsed) == bookmarks_to_pdftk_format(parsed)


def test_replace_bookmarks_in_pdftk() -> None:
    original = (
        "InfoBegin\n"
        "NumberOfPages: 5\n"
        "BookmarkBegin\nBookmarkTitle: Old\nBookmarkLevel: 1\nBookmarkPageNumber: 1\n"
        "PageMediaBegin\nPageMediaNumber: 1"
    )
    new = "BookmarkBegin\nBookmarkTitle: New\nBookmarkLevel: 1\nBookmarkPageNumber: 3"
    result = replace_bookmarks_in_pdftk(original, new)
    assert "Old" not in result
    assert "BookmarkTitle: New" in result
    # Preserves the header (before NumberOfPages) and footer (from PageMediaBegin).
    assert result.startswith("InfoBegin\n")
    assert result.strip().endswith("PageMediaNumber: 1")
