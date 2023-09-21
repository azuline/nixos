vim.opt.completeopt = "menu,menuone,noselect"

vim.g.coq_settings = {
  auto_start = "shut-up",
  display = { pum = { fast_close = false } },
  clients = {
    tmux = { enabled = true },
    paths = { enabled = true },
    tags = { enabled = false },
    snippets = { enabled = true, weight_adjust = 1.5 },
    tree_sitter = { enabled = true },
  },
}
