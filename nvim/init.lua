-- These need to be configured before we load plugins.
vim.g.polyglot_disabled = { "markdown" }
vim.g.markdown_enable_conceal = 1

-- Setting Coq colors, needs to be configured before we load the plugin.
vim.cmd([[
  augroup CoqtailHighlights
    autocmd!
    autocmd ColorScheme *
      \   hi def CoqtailChecked ctermbg=236 guibg=#292D3E
      \ | hi def CoqtailSent    ctermbg=236 guibg=#292D3E
      \ | hi def link CoqtailError Error
  augroup END
]])

do -- Load the plugins.
  vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
  local Plug = vim.fn["plug#"]

  -- General dependency.
  Plug("nvim-lua/plenary.nvim")

  do -- Editor augmentation
    -- Text objects for expanding/contracting syntactic constructs
    Plug("RRethy/nvim-treesitter-textsubjects")
    -- Bullet points, because the replacement Markdown plugins all suck
    Plug("dkarter/bullets.vim")
    -- Extra text objects for braces/quotes/tags. targets.vim gets us things
    -- _inside_ the tags, vim-surround has fancy stuff for _outside_ the tags.
    Plug("wellle/targets.vim")
    Plug("tpope/vim-surround")
    -- Comment/uncomment assistance (because I'm slow)
    Plug("tpope/vim-commentary")
    -- Pluralization & case coercion
    Plug("tpope/vim-abolish")
    -- Give me readline in command mode!
    Plug("tpope/vim-rsi")
    -- Repeat for plugins
    Plug("tpope/vim-repeat")
    -- Text alignment operator
    Plug("tommcdo/vim-lion")
    -- Toggle between singleline and multiline syntax
    Plug("AndrewRadev/splitjoin.vim")
    -- Sublime style multiple cursors
    Plug("mg979/vim-visual-multi")
  end

  do -- Navigation
    -- Fuzzy finder
    Plug("junegunn/fzf", { ["do"] = vim.fn["fzf#install()"] })
    Plug("junegunn/fzf.vim")
    -- File tree
    Plug("ms-jpq/chadtree", { branch = "chad", ["do"] = "python3 -m chadtree deps" })
  end

  do -- Window visuals
    -- Theme
    Plug("drewtempelmeyer/palenight.vim")
    -- Statusline
    Plug("itchyny/lightline.vim")
    Plug("spywhere/lightline-lsp")
    Plug("mengelbrecht/lightline-bufferline")
    -- Git gutter
    Plug("mhinz/vim-signify")
  end

  do -- Language/Syntax Plugins
    -- Language parser & highlighting
    -- We use polyglot for indentation, since tree-sitter is not mature.
    Plug("sheerun/vim-polyglot")
    Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
    -- Coq
    Plug("whonore/Coqtail")
    -- Markdown
    Plug("gabrielelana/vim-markdown")
    -- LaTeX!
    Plug("lervag/vimtex", { tag = "v1.6" })
    Plug("KeitaNakamura/tex-conceal.vim", { ["for"] = "tex" })
    -- CSS
    Plug("ap/vim-css-color")
  end

  do -- Development Tooling
    -- Default LSP configs
    Plug("neovim/nvim-lspconfig")
    -- Null-ls for editors/autoformatters -> LSP
    Plug("jose-elias-alvarez/null-ls.nvim")
    Plug("jose-elias-alvarez/nvim-lsp-ts-utils")
    -- Other LSP plugins
    Plug("onsails/lspkind-nvim")
    Plug("simrat39/rust-tools.nvim")
    -- Quickfix & Diagnostics
    Plug("folke/trouble.nvim")
    -- Git Client
    Plug("tpope/vim-fugitive")
    -- Test Runner
    Plug("vim-test/vim-test")
  end

  do -- Completion
    Plug("ms-jpq/coq_nvim", { branch = "coq", ["do"] = ":COQdeps" })
  end

  vim.call("plug#end")
end

-- Load in sections!
require("window")
require("navigation")
require("dev")
require("lsp")
require("completion")

-- Set the spellfile.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

-- Selectively enable bullets behavior for these filetypes.
vim.g.bullets_enabled_file_types = {
  "markdown",
  "text",
  "gitcommit",
  "scratch",
}
