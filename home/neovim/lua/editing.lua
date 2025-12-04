-- Have vim-lion remove excess spaces when aligning characters.
vim.g.lion_squeeze_spaces = 1

-- Configure barbaric.
vim.g.barbaric_ime = "ibus"
vim.g.barbaric_default = "xkb:us::eng"

-- Spell check.
vim.opt.spellfile = vim.fn.expand("$HOME/.config/nvim/spell/en.utf-8.add")
vim.cmd([[
	au BufEnter *.md,*.mkd,*.markdown,*.rst,*.tex,*.txt,*.typ setlocal spell | setlocal spellcapcheck=
]])
