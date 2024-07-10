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
  local actions = require("telescope.actions")
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          -- Allow esc to close the window in insert mode.
          ["<ESC>"] = actions.close,
          -- Allow ctrl+u to clear the prompt in insert mode.
          ["<C-u>"] = false,
        },
      },
    },
    pickers = {
      live_grep = {
        previewer = false,
      },
    },
  })
  telescope.load_extension("fzf")
  -- Disable the nvim-cmp prompt in Telescope.
  vim.cmd([[
		autocmd FileType TelescopePrompt lua require'cmp'.setup.buffer {
		\   completion = { autocomplete = false }
		\ }
	]])
  vim.api.nvim_set_keymap("n", "<Leader>.", "<Cmd>Telescope find_files<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>Telescope live_grep<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>Telescope buffers<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<C-]>", "<Cmd>Telescope lsp_definitions<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>ra", "<Cmd>Telescope lsp_references<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>ri", "<Cmd>Telescope lsp_incoming_calls<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>ro", "<Cmd>Telescope lsp_outgoing_calls<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>ca", "<Cmd>Telescope commands<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>ch", "<Cmd>Telescope command_history<CR>", { noremap = true })
  vim.g.fzf_vim = {
    preview_window = { "up,40%,hidden", "ctrl-/" },
  }
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
