-- Auto-write \item when writing a <CR> inside a list.
local function insert_item()
  if
    vim.fn.searchpair("\\\\begin{itemize}", "", "\\\\end{itemize}", "nW") > 0
    or vim.fn.searchpair("\\\\begin{enumerate}", "", "\\\\end{enumerate}", "nW") > 0
  then
    return "<CR><BS>\\item "
  else
    return "<CR>"
  end
end

vim.keymap.set("i", "<CR>", insert_item, { buffer = true, expr = true, noremap = true })
