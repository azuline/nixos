vim.treesitter = nil

require("plugins")
require("window")
require("navigation")
require("completion") -- This needs to be before LSP.
require("lsp")
require("dev")
require("editing")
