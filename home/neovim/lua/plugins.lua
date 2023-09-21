-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- GENERAL DEPENDENCY
  { "nvim-lua/plenary.nvim" },

  -- EDITOR AUGMENTATION
  -- Text objects for expanding/contracting syntactic constructs
  { "RRethy/nvim-treesitter-textsubjects" },
  -- Bullet points, because the replacement Markdown plugins all suck
  { "dkarter/bullets.vim" },
  -- Extra text objects for braces/quotes/tags. targets.vim gets us things
  -- _inside_ the tags, vim-surround has fancy stuff for _outside_ the tags.
  { "wellle/targets.vim" },
  { "tpope/vim-surround" },
  -- Comment/uncomment assistance (because I'm slow)
  { "tpope/vim-commentary" },
  -- Pluralization & case coercion
  { "tpope/vim-abolish" },
  -- Give me readline in command mode!
  { "tpope/vim-rsi" },
  -- Repeat for plugins
  { "tpope/vim-repeat" },
  -- Text alignment operator
  { "tommcdo/vim-lion" },
  -- Toggle between singleline and multiline syntax
  { "AndrewRadev/splitjoin.vim" },
  -- Sublime style multiple cursors
  { "mg979/vim-visual-multi" },

  -- NAVIGATION
  -- Fuzzy finder
  {
    "junegunn/fzf.vim",
    dependencies = {
      { "junegunn/fzf", build = vim.fn["fzf#install()"] },
    },
  },
  -- File tree
  { "azuline/chadtree", branch = "chad", build = "python3 -m chadtree deps" },

  -- WINDOW VISUALS
  -- Theme
  { "azuline/palenight.vim", priority = 90 },
  -- Statusline
  {
    "itchyny/lightline.vim",
    dependencies = {
      { "spywhere/lightline-lsp" },
      { "mengelbrecht/lightline-bufferline" },
    },
  },
  -- Git gutter
  { "mhinz/vim-signify" },

  -- LANGUAGE/SYNTAX PLUGINS
  -- Treesitter is installed and symlinked into the specified directory by Nix.
  -- This is because a lot of parsers use shared libs, which break in Nix.
  -- We use polyglot for indentation, since tree-sitter is not mature.
  { "sheerun/vim-polyglot" },
  -- LaTeX!
  { "lervag/vimtex", tag = "v1.6" },
  { "KeitaNakamura/tex-conceal.vim", ft = "tex" },

  -- DEVELOPMENT TOOLING
  -- Default LSP configs
  { "neovim/nvim-lspconfig" },
  -- Null-ls for editors/autoformatters -> LSP
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      { "jose-elias-alvarez/nvim-lsp-ts-utils" },
    },
  },
  -- Other LSP plugins
  { "simrat39/rust-tools.nvim" },
  -- Git Client
  { "tpope/vim-fugitive" },
  -- Test Runner
  { "vim-test/vim-test" },

  -- COMPLETION
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      -- Snippets
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  },
}, {
  -- Load plugins installed with Nix.
  performance = {
    reset_packpath = false,
    rtp = { reset = false },
  },
})
