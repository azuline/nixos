vim.opt.completeopt = "menu,menuone,noselect"

-- Setup nvim-cmp.
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
    -- ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    -- ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    { name = "vsnip" },
  }, {
    { name = "buffer", keyword_length = 3 },
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
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
    -- disable completion in comments
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
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

-- Snippet movement hotkeys
vim.api.nvim_set_keymap("i", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
vim.api.nvim_set_keymap(
  "i",
  "<S-Tab>",
  "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev-next)' : '<S-Tab>'",
  { expr = true }
)
vim.api.nvim_set_keymap(
  "x",
  "<S-Tab>",
  "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev-next)' : '<S-Tab>'",
  { expr = true }
)
