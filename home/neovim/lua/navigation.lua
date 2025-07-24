do -- File browser
	require("nnn").setup({
		explorer = {
			width = 32,
			fullscreen = false,
		},
		auto_close = true,
		replace_netrw = "picker",
		windownav = {
			left = "<C-h>",
			right = "<C-l>",
			next = "<C-j>",
			prev = "<C-k>",
		},
	})
	vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>NnnExplorer %:p:h<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>c", "<Cmd>call setqflist([])<CR>", { noremap = true })
end

do -- Telescope
	require("fzf-lua").setup({
		"ivy",
		winopts = {
			height = 0.5,
			backdrop = 0,
		},
		grep = {
			multiline = 1,
		},
	})

	vim.api.nvim_set_keymap("n", "<Leader>.", "<Cmd>lua FzfLua.files()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>lua FzfLua.live_grep_native()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>lua FzfLua.buffers()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<C-]>", "<Cmd>lua FzfLua.lsp_definitions()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>ra", "<Cmd>lua FzfLua.lsp_references()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>ca", "<Cmd>lua FzfLua.commands()<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<Leader>ch", "<Cmd>lua FzfLua.command_history()<CR>", { noremap = true })
end

do -- Tab Bar
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
