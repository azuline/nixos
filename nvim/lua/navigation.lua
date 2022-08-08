-- Tree browser
do
	vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>CHADopen<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>c", "<Cmd>call setqflist([])<CR>", { noremap = true })

	local chadtree_settings = {
		ignore = {
			name_exact = {
				".DS_Store",
				".directory",
				"thumbs.db",
				".git",
				"node_modules",
				"__pycache__",
				"build",
				"dist",
			},
		},
		-- Eh, this doesn"t work with native theme, but nord looks alright.
		theme = {
			text_colour_set = "nord",
		},
		view = {
			window_options = {
				number = true,
				relativenumber = true,
			},
		},
	}
	vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
end

-- Fuzzy File Finder
do
	-- Git Files
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>.",
		"<Cmd>GitFiles! --cached --others --exclude-standard<CR>",
		{ noremap = true }
	)
	-- Ripgrep
	vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>Rg!<CR>", { noremap = true })
	-- Command All
	vim.api.nvim_set_keymap("n", "<Leader>ca", "<Cmd>Commands!<CR>", { noremap = true })
	-- Command History
	vim.api.nvim_set_keymap("n", "<Leader>ch", "<Cmd>History:!<CR>", { noremap = true })
	-- History File
	vim.api.nvim_set_keymap("n", "<Leader>hf", "<Cmd>GV!<CR>", { noremap = true })
	-- History All
	vim.api.nvim_set_keymap("n", "<Leader>ha", "<Cmd>GV<CR>", { noremap = true })
	-- Configure FZF preview window.
	vim.g.fzf_preview_window = { "up:40%:hidden", "ctrl-/" }
end

-- Tab Bar
do
	vim.api.nvim_set_keymap("n", "<Leader>1", "<Plug>lightline#bufferline#go(1)", {})
	vim.api.nvim_set_keymap("n", "<Leader>2", "<Plug>lightline#bufferline#go(2)", {})
	vim.api.nvim_set_keymap("n", "<Leader>3", "<Plug>lightline#bufferline#go(3)", {})
	vim.api.nvim_set_keymap("n", "<Leader>4", "<Plug>lightline#bufferline#go(4)", {})
	vim.api.nvim_set_keymap("n", "<Leader>5", "<Plug>lightline#bufferline#go(5)", {})
	vim.api.nvim_set_keymap("n", "<Leader>6", "<Plug>lightline#bufferline#go(6)", {})
	vim.api.nvim_set_keymap("n", "<Leader>7", "<Plug>lightline#bufferline#go(7)", {})
	vim.api.nvim_set_keymap("n", "<Leader>8", "<Plug>lightline#bufferline#go(8)", {})
	vim.api.nvim_set_keymap("n", "<Leader>9", "<Plug>lightline#bufferline#go(9)", {})
	vim.api.nvim_set_keymap("n", "<Leader>0", "<Plug>lightline#bufferline#go(10)", {})

	-- Delete buffer.
	vim.api.nvim_set_keymap("n", "<Leader>d1", "<Plug>lightline#bufferline#delete(1)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d2", "<Plug>lightline#bufferline#delete(2)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d3", "<Plug>lightline#bufferline#delete(3)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d4", "<Plug>lightline#bufferline#delete(4)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d5", "<Plug>lightline#bufferline#delete(5)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d6", "<Plug>lightline#bufferline#delete(6)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d7", "<Plug>lightline#bufferline#delete(7)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d8", "<Plug>lightline#bufferline#delete(8)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d9", "<Plug>lightline#bufferline#delete(9)", {})
	vim.api.nvim_set_keymap("n", "<Leader>d0", "<Plug>lightline#bufferline#delete(10)", {})

	vim.g["lightline#bufferline#show_number"] = 2
	vim.g["lightline#bufferline#min_buffer_count"] = 2
end
