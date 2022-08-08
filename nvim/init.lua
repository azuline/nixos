-- Set the spellfile.
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

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

-- Load the plugins.
do
-- Perhaps one day I will be sane and cherry-pick things from these plugins
-- that I need while forgoing the remaining bloat. However, right now, I"m
-- lazy, my computer is fast, and I don"t want to devote the time.
vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")
local Plug = vim.fn["plug#"]

-- General dependency.
Plug("nvim-lua/plenary.nvim")

-- Navigation
do
	-- Fuzzy finder
	Plug("junegunn/fzf", {
		["do"] = vim.fn["fzf#install()"],
	})
	Plug("junegunn/fzf.vim")
	-- File tree
	Plug("ms-jpq/chadtree", {
		branch = "chad",
		["do"] = "python3 -m chadtree deps",
	})
end

-- Visuals
do
	-- Theme
	Plug("drewtempelmeyer/palenight.vim")
	-- Statusline
	Plug("itchyny/lightline.vim")
	Plug("spywhere/lightline-lsp")
	Plug("mengelbrecht/lightline-bufferline")
	-- Git gutter
	Plug("mhinz/vim-signify")
	-- Extra file context
	-- Breaks in Fern. TODO: Try reenabling.
	-- Plug("wellle/context.vim")
end

-- Language/Syntax Plugins
do
	-- Language parser & highlighting
	-- We use polyglot for indentation, since tree-sitter is not mature.
	Plug("sheerun/vim-polyglot")
	Plug("nvim-treesitter/nvim-treesitter", {
		["do"] = ":TSUpdate",
	})
	-- Coq
	Plug("whonore/Coqtail")
	-- Markdown
	Plug("gabrielelana/vim-markdown")
	-- LaTeX!
	Plug("lervag/vimtex", { tag = "v1.6" })
	Plug("KeitaNakamura/tex-conceal.vim", {
		["for"] = "tex",
	})
end

-- Editor augmentation
do
	-- Bullet points, because the replacement Markdown plugins all suck
	Plug("dkarter/bullets.vim")
	-- Comment/uncomment assistance (because I"m slow)
	Plug("tpope/vim-commentary")
	-- Pluralization & case coercion
	Plug("tpope/vim-abolish")
	-- Extra text objects
	Plug("wellle/targets.vim")
	-- Surrounding objects mutation
	Plug("tpope/vim-surround")
	-- Text alignment operator
	Plug("tommcdo/vim-lion")
	-- Repeat for plugins
	Plug("tpope/vim-repeat")
	-- Sublime style multiple cursors
	Plug("mg979/vim-visual-multi", { branch = "master" })
	-- Color highlighting.
	Plug("ap/vim-css-color")
end

-- Language Server Protocol
do
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
	-- Snippets to stop nvim-cmp from crashing.
	Plug("hrsh7th/cmp-vsnip")
	Plug("hrsh7th/vim-vsnip")
end

-- Developer tooling
do
	-- Git Client
	Plug("tpope/vim-fugitive")
	-- Git History Viewer
	Plug("junegunn/gv.vim")
	-- Test Runner
	Plug("vim-test/vim-test")
end

vim.call("plug#end")
end

require("window")
require("navigation")
require("lsp")
require("completion")

-- Treesitter configuration.
require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ignore_install = { "javascript" }, -- List of parsers to ignore installing
	-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1019#issuecomment-811658387
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = {}, -- list of language that will be disabled
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = false,
	},
})

-- Behavior tweaks

-- Bullets
do
	-- Selectively enable bullets behavior for these filetypes.
	vim.g.bullets_enabled_file_types = {
		"markdown",
		"text",
		"gitcommit",
		"scratch",
	}
end

-- Vim-test Keybinds
do
	vim.api.nvim_set_keymap("n", "<Leader>tn", "<Cmd>TestNearest<CR>", { silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>tf", "<Cmd>TestFile<CR>", { silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>ts", "<Cmd>TestSuite<CR>", { silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>tl", "<Cmd>TestLast<CR>", { silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>tg", "<Cmd>TestVisit<CR>", { silent = true })
end

-- Quickfix augmentations
do
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
