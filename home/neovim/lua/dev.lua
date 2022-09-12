do -- Vim-Test Keybinds
  vim.api.nvim_set_keymap("n", "<Leader>tn", "<Cmd>TestNearest<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tf", "<Cmd>TestFile<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>ts", "<Cmd>TestSuite<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tl", "<Cmd>TestLast<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>tg", "<Cmd>TestVisit<CR>", { silent = true })
end

do -- Quickfix augmentations
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
  -- Open all files in the quickfix list into buffers.
  vim.api.nvim_set_keymap("n", "<Leader>ea", "<Cmd>call OpenQuickfixList()<CR>", {})
end

do -- Trouble - Diagnostics from LSP/Quickfix
  require("trouble").setup({
    fold_open = "▼",
    fold_closed = "▶",
    icons = false,
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" }, -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" }, -- open buffer in new tab
      jump_close = { "o" }, -- jump to the diagnostic and close the list
      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small popup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = { "zM", "zm" }, -- close all folds
      open_folds = { "zR", "zr" }, -- open all folds
      toggle_fold = { "zA", "za" }, -- toggle fold of current file
      previous = "k", -- preview item
      next = "j", -- next item
    },
  })

  vim.api.nvim_set_keymap("n", "<Leader>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>xq", "<Cmd>TroubleToggle quickfix<CR>", { noremap = true })
  vim.api.nvim_set_keymap(
    "n",
    "<Leader>xn",
    "<Cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>",
    { noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<Leader>xp",
    "<Cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>",
    { noremap = true }
  )
end
