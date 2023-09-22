vim.opt.completeopt = "menu,menuone,noselect"

vim.g.coq_settings = {
  auto_start = "shut-up",
  display = { pum = { fast_close = false } },
  keymap = {
    -- Should be <c-l> but only in insert mode. I need to figure out how this
    -- actually behaves first.
    jump_to_mark = "<Leader>l",
  },
  clients = {
    tmux = { enabled = true },
    paths = { enabled = true },
    tags = { enabled = false },
    snippets = { enabled = true, weight_adjust = 1.5 },
    tree_sitter = { enabled = true },
  },
}
