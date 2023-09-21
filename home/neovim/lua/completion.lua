vim.opt.completeopt = "menu,menuone,noselect"

vim.g.coq_settings = {
  auto_start = "shut-up",
  display = {
		pum = { fast_close = false },
		snippets = { enabled = true, weight_adjust = 1.5 },
		paths = { enabled = true },
		tree_sitter = { enabled = true },
		buffers = { enabled = true },
		tmux = { enabled = true },
		tags = { enabled = false },
  },
}
