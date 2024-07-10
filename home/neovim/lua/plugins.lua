do -- Load the plugins.
  vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
  local Plug = vim.fn["plug#"]

  -- General dependency.
  Plug("nvim-lua/plenary.nvim")

  do -- Editor augmentation
    -- Text objects for expanding/contracting syntactic constructs
    Plug("nvim-treesitter/nvim-treesitter-textobjects")
    -- Extra text objects for stuff inside braces/quotes/tags.
    Plug("wellle/targets.vim")
    -- Extra text objects for stuff outside braces/quotes/tags.
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

  do -- Navigation
    -- Fuzzy finder
    Plug("nvim-telescope/telescope.nvim")
    Plug(
      "nvim-telescope/telescope-fzf-native.nvim",
      { ["do"] = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" }
    )
    -- File tree
    Plug("luukvbaal/nnn.nvim")
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
    -- nvim-cmp
    Plug("hrsh7th/cmp-nvim-lsp")
    Plug("hrsh7th/cmp-buffer")
    Plug("hrsh7th/cmp-path")
    Plug("hrsh7th/cmp-cmdline")
    Plug("hrsh7th/nvim-cmp")
    Plug("onsails/lspkind.nvim")
    -- Snippets
    Plug("hrsh7th/cmp-vsnip")
    Plug("hrsh7th/vim-vsnip")
  end

  vim.call("plug#end")
end
