-- Set the spellfile.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

-- Load in sections!
require("plugins")
require("window")
require("navigation")
require("dev")
require("lsp")
require("completion")
require("editing")
