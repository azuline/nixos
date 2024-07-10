vim.opt.completeopt = "menu,menuone,noselect"

vim.g.coq_settings = {
  auto_start = "shut-up",
  display = { pum = { fast_close = false } },
  keymap = {
    -- This is some bullshit keybind we'll never call, in order to disable
    -- this. It acts up and causes delays and lags if we set it to anything
    -- reasonable, and then it overrides <c-l> in normal mode. Instead, we
    -- manually set this keybind below only in insert mode.
    jump_to_mark = "<c-_>",
  },
  clients = {
    tmux = { enabled = true },
    lsp = { enabled = true, resolve_timeout = 1.0 },
    paths = { enabled = true },
    tags = { enabled = false },
    snippets = { enabled = true, weight_adjust = 1.5 },
    tree_sitter = { enabled = true },
  },
}

vim.api.nvim_set_keymap("i", "<c-l>", "<Cmd>lua COQ.Nav_mark()<CR>", {})
