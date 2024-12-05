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

-- Spell check.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"
vim.cmd([[
	au BufEnter *.md,*.mkd,*.markdown,*.rst,*.tex,*.txt setlocal spell | setlocal spellcapcheck=
]])
