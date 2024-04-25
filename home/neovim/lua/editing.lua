-- Selectively enable bullets behavior for these filetypes.
vim.g.bullets_enabled_file_types = {
  "markdown",
  "text",
  "gitcommit",
  "scratch",
}

-- Have vim-lion remove excess spaces when aligning characters.
vim.g.lion_squeeze_spaces = 1

-- Configure barbaric.
vim.g.barbaric_ime = "ibus"
vim.g.barbaric_default = "xkb:us::eng"
