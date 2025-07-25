vim.opt.completeopt = "menu,menuone,noselect"

do -- Setup nvim-cmp.
	local cmp = require("cmp")
	local lspkind = require("lspkind")

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local select_next_item = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif has_words_before() then
			cmp.complete()
		else
			-- The fallback function sends a already mapped key. In this case, it"s probably `<Tab>`.
			fallback()
		end
	end, { "i", "s" })

	local select_previous_item = cmp.mapping(function()
		if cmp.visible() then
			cmp.select_prev_item()
		end
	end, { "i", "s" })

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
			["<C-y>"] = cmp.config.disable,
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			["<Tab>"] = select_next_item,
			["<C-n>"] = select_next_item,
			["<S-Tab>"] = select_previous_item,
			["<C-p>"] = select_previous_item,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			-- Snippets keep on firing on the most random characters. Extremely
			-- unhelpful. I never call them from autocomplete anyways, I ctrl-j them.
			-- { name = "vsnip" },
		}, {
			{
				name = "buffer",
				keyword_length = 3,
				-- Pull autocompletion from all buffers.
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "text",
				menu = {
					buffer = "[buf]",
					nvim_lsp = "[lsp]",
					vsnip = "[snip]",
					path = "[path]",
					latex_symbols = "[tex]",
				},
			}),
		},
		experimental = {
			ghost_text = true,
		},
		enabled = function()
			-- disable nvim-cmp in Telescope prompt buffers
			local buftype = vim.api.nvim_buf_get_option(0, "buftype")
			if buftype == "prompt" then
				return false
			end
			-- otherwise enable
			return true
		end,
	})

	-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "buffer", keyword_length = 3 },
		}),
	})

	-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path", keyword_length = 3 },
		}, {
			{ name = "cmdline", keyword_length = 3 },
		}),
	})
end

do -- Set up snippets
	vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets")

	-- Expand snippets
	vim.api.nvim_set_keymap("i", "<C-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", { expr = true })
	vim.api.nvim_set_keymap("s", "<C-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", { expr = true })

	-- Snippet movement hotkeys
	vim.api.nvim_set_keymap("i", "<C-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-l>'", { expr = true })
	vim.api.nvim_set_keymap("s", "<C-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-l>'", { expr = true })
	vim.api.nvim_set_keymap(
		"i",
		"<C-h>",
		"vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev-next)' : '<C-h>'",
		{ expr = true }
	)
	vim.api.nvim_set_keymap(
		"x",
		"<C-h>",
		"vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev-next)' : '<C-h>'",
		{ expr = true }
	)

	-- Snippets for multiple filetypes.
	vim.g.vsnip_filetypes = {
		javascriptreact = { "javascript" },
		typescriptreact = { "typescript" },
	}
end
