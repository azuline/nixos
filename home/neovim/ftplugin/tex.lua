-- Auto-write \item when writing a <CR> inside a list.
local function insert_item()
  if
    vim.fn.searchpair("\\\\begin{itemize}", "", "\\\\end{itemize}", "nW") > 0
    or vim.fn.searchpair("\\\\begin{enumerate}", "", "\\\\end{enumerate}", "nW") > 0
  then
    return vim.api.nvim_put({ "", "  \\item " }, "c", true, true)
  else
    return vim.api.nvim_put({ "", "" }, "c", false, true)
    -- return vim.api.nvim_input("<CR>")
  end
end

vim.keymap.set("i", "<CR>", insert_item, { buffer = true, noremap = true })
