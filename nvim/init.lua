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

  do -- Navigation
    -- Fuzzy finder
    Plug("junegunn/fzf", { ["do"] = vim.fn["fzf#install()"] })
    Plug("junegunn/fzf.vim")
    -- File tree
    Plug("ms-jpq/chadtree", { branch = "chad", ["do"] = "python3 -m chadtree deps" })
  end

  do -- Visuals
    -- Theme
    Plug("drewtempelmeyer/palenight.vim")
    -- Statusline
    Plug("itchyny/lightline.vim")
    Plug("spywhere/lightline-lsp")
    Plug("mengelbrecht/lightline-bufferline")
    -- Git gutter
    Plug("mhinz/vim-signify")
    -- Extra file context
    Plug("wellle/context.vim")
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

  do -- Language Server Protocol
    -- Default LSP configs
    Plug("neovim/nvim-lspconfig")
    -- Null-ls for editors/autoformatters -> LSP
    Plug("jose-elias-alvarez/null-ls.nvim")
    Plug("jose-elias-alvarez/nvim-lsp-ts-utils")
    -- Other LSP plugins
    Plug("onsails/lspkind-nvim")
    Plug("simrat39/rust-tools.nvim")
    -- nvim-cmp
    Plug("hrsh7th/cmp-nvim-lsp")
    Plug("hrsh7th/cmp-buffer")
    Plug("hrsh7th/cmp-path")
    Plug("hrsh7th/cmp-cmdline")
    Plug("hrsh7th/nvim-cmp")
    Plug("hrsh7th/cmp-nvim-lsp-signature-help")
    -- Snippets to stop nvim-cmp from crashing.
    Plug("hrsh7th/cmp-vsnip")
    Plug("hrsh7th/vim-vsnip")
  end

  do -- Developer tooling
    -- Git Client
    Plug("tpope/vim-fugitive")
    -- Test Runner
    Plug("vim-test/vim-test")
  end

  vim.call("plug#end")
end

-- Load in sections!
require("window")
require("navigation")
require("lsp")
require("completion")

-- Set the spellfile.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

-- Miscellanous behavior tweaks

do -- Vim-test Keybinds
  vim.api.nvim_set_keymap("n", "<Leader>tn", "<Cmd>TestNearest<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tf", "<Cmd>TestFile<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>ts", "<Cmd>TestSuite<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tl", "<Cmd>TestLast<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tg", "<Cmd>TestVisit<CR>", { silent = true })
end

do -- Quickfix augmentations
  vim.cmd([[
		function! OpenQuickfixList()
			if empty(getqflist())
				return
			endif

			let s:prev_val = ""
			for d in getqflist()
					let s:curr_val = bufname(d.bufnr)
					if (s:curr_val != s:prev_val)
							"echo s:curr_val
							exec "edit " . s:curr_val
					end
					let s:prev_val = s:curr_val
			endfor
		endfunction
	]])
  vim.api.nvim_set_keymap("n", "<Leader>ea", "<Cmd>call OpenQuickFixList()<CR>", {})
end

-- Selectively enable bullets behavior for these filetypes.
vim.g.bullets_enabled_file_types = {
  "markdown",
  "text",
  "gitcommit",
  "scratch",
}