from __future__ import annotations

import os
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

import click


@dataclass
class Bookmark:
    title: str
    pageno: int
    level: int
    children: list[Bookmark]

    def to_user_format(self, indent_level: int = 0) -> str:
        """Convert to user-friendly format: page number + indented title"""
        lines = []
        indent = " " * indent_level
        lines.append(f"{indent}{self.pageno} {self.title}")
        for child in self.children:
            lines.extend(child.to_user_format(indent_level + 1).split("\n"))
        return "\n".join(lines)


def parse_from_pdftk(content: str) -> list[Bookmark]:
    """Parse pdftk output into bookmark datastructures"""
    lines = content.split("\n")
    start_idx = next(i for i, line in enumerate(lines) if line.startswith("NumberOfPages:"))
    end_idx = next(i for i, line in enumerate(lines) if line.startswith("PageMediaBegin"))
    bookmark_lines = lines[start_idx:end_idx]

    i = 0
    bookmarks = []
    bookmark_stack = []
    while i < len(bookmark_lines):
        line = bookmark_lines[i].strip()
        # Read the next three lines for title, level, and page
        if line != "BookmarkBegin":
            i += 1
            continue
        assert i + 3 < len(bookmark_lines)
        title_line = bookmark_lines[i + 1].strip()
        level_line = bookmark_lines[i + 2].strip()
        page_line = bookmark_lines[i + 3].strip()
        assert title_line.startswith("BookmarkTitle:") and level_line.startswith("BookmarkLevel:") and page_line.startswith("BookmarkPageNumber:"), bookmark_lines[i : i + 4]
        title = title_line.split("BookmarkTitle:", 1)[1].strip()
        level = int(level_line.split("BookmarkLevel:", 1)[1].strip())
        page = int(page_line.split("BookmarkPageNumber:", 1)[1].strip())
        bookmark = Bookmark(title=title, pageno=page, level=level, children=[])

        while bookmark_stack and bookmark_stack[-1].level >= level:
            bookmark_stack.pop()
        if bookmark_stack:
            bookmark_stack[-1].children.append(bookmark)
        else:
            bookmarks.append(bookmark)
        bookmark_stack.append(bookmark)

        i += 4

    return bookmarks


def parse_from_editable(content: str) -> list[Bookmark]:
    """Parse user-friendly format back into bookmark datastructures"""
    lines = [line.rstrip() for line in content.split("\n") if line.strip()]
    bookmarks = []
    bookmark_stack = []

    for line in lines:
        level = len(line) - len(line.lstrip(" "))
        content_part = line.lstrip(" ")

        parts = content_part.split(" ", 1)
        assert len(parts) == 2
        page = int(parts[0])
        title = parts[1]

        bookmark = Bookmark(title=title, pageno=page, level=level + 1, children=[])

        while bookmark_stack and bookmark_stack[-1].level > level:
            bookmark_stack.pop()
        if bookmark_stack and bookmark_stack[-1].level == level:
            bookmark_stack.pop()
        if bookmark_stack:
            bookmark_stack[-1].children.append(bookmark)
        else:
            bookmarks.append(bookmark)
        bookmark_stack.append(bookmark)

    return bookmarks


def bookmarks_to_pdftk_format(bookmarks: list[Bookmark]) -> str:
    """Convert bookmarks back to pdftk format"""
    lines = []

    def add_bookmark(bookmark: Bookmark):
        lines.append("BookmarkBegin")
        lines.append(f"BookmarkTitle: {bookmark.title}")
        lines.append(f"BookmarkLevel: {bookmark.level}")
        lines.append(f"BookmarkPageNumber: {bookmark.pageno}")
        for child in bookmark.children:
            add_bookmark(child)

    for bookmark in bookmarks:
        add_bookmark(bookmark)
    return "\n".join(lines)


def replace_bookmarks_in_pdftk(original_content: str, new_bookmarks: str) -> str:
    """Replace bookmark section in pdftk output with new bookmarks"""
    lines = original_content.split("\n")
    start_idx = next(i for i, line in enumerate(lines) if line.startswith("NumberOfPages:"))
    end_idx = next(i for i, line in enumerate(lines) if line.startswith("PageMediaBegin"))
    before = lines[:start_idx]
    after = lines[end_idx:]
    return "\n".join(before + new_bookmarks.split("\n") + after)


@click.command()
@click.argument("src_pdf", type=click.Path(exists=True))
@click.option("--raw", is_flag=True, help="Edit raw pdftk format instead of user-friendly format")
def main(src_pdf: str, raw: bool):
    """Edit PDF table of contents"""

    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)
        bookmarks_file = tmpdir / "pdftk-out.txt"
        edit_file = tmpdir / "edit.txt"
        modified_pdf_file = tmpdir / "modified.pdf"

        subprocess.run(["pdftk", src_pdf, "data_dump", "output", str(bookmarks_file)], check=True)

        if raw:
            subprocess.run([os.environ["EDITOR"], str(bookmarks_file)], check=True)
            with bookmarks_file.open("r") as f:
                final_content = f.read()
        else:
            with bookmarks_file.open("r") as f:
                pdftk_content = f.read()
            bookmarks = parse_from_pdftk(pdftk_content)
            user_content = "\n".join(bookmark.to_user_format() for bookmark in bookmarks)
            with edit_file.open("w") as f:
                f.write(user_content)
            subprocess.run([os.environ["EDITOR"], str(edit_file)], check=True)
            with edit_file.open("r") as f:
                edited_content = f.read()
            edited_bookmarks = parse_from_editable(edited_content)
            new_bookmark_section = bookmarks_to_pdftk_format(edited_bookmarks)
            final_content = replace_bookmarks_in_pdftk(pdftk_content, new_bookmark_section)
            with bookmarks_file.open("w") as f:
                f.write(final_content)

        subprocess.run(["pdftk", src_pdf, "update_info", str(bookmarks_file), "output", str(modified_pdf_file)], check=True)
        modified_pdf_file.rename(src_pdf)


if __name__ == "__main__":
    main()
