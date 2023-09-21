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
