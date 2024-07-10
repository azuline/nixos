do -- Load the plugins.
  vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
  local Plug = vim.fn["plug#"]

  -- General dependency.
  Plug("nvim-lua/plenary.nvim")

  do -- Editor augmentation
    -- Text objects for expanding/contracting syntactic constructs
    Plug("nvim-treesitter/nvim-treesitter-textobjects")
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
    -- ibus integration (back to eng in normal mode)
    Plug("rlue/vim-barbaric")
  end

  do -- Navigation
    -- Fuzzy finder
    Plug("junegunn/fzf")
    Plug("junegunn/fzf.vim")
    -- File tree
    Plug("azuline/chadtree", { branch = "chad", ["do"] = "python3 -m chadtree deps" })
  end

  do -- Window visuals
    -- Theme
    Plug("azuline/palenight.vim")
    -- Statusline
    Plug("itchyny/lightline.vim")
    Plug("spywhere/lightline-lsp")
    Plug("mengelbrecht/lightline-bufferline")
    -- Git gutter
    Plug("mhinz/vim-signify")
  end

  do -- Language/Syntax Plugins
    -- Treesitter is handled via Nix since installing the dynamically linked
    -- parsers breaks in Nix. For languages where tree-sitter is not fully
    -- mature, we use language-specific plugins for indentation.
    Plug("lervag/vimtex")
  end

  do -- Development Tooling
    -- Prepackaged "default" LSP configs
    Plug("neovim/nvim-lspconfig")
    -- None-ls for integrating editors/autoformatters with LSP
    Plug("nvimtools/none-ls.nvim")
    -- Other LSP plugins
    Plug("mrcjkb/rustaceanvim")
    Plug("pmizio/typescript-tools.nvim")
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
