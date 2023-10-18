-- Set the spellfile.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

-- Load in sections!
require("plugins")
require("window")
require("navigation")
require("completion") -- This needs to be before LSP.
require("lsp")
require("dev")
require("editing")
