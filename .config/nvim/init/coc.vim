" CoC LSP Client
" ==============

let g:coc_global_extensions = [
\ 'coc-json', 
\ 'coc-css',
\ 'coc-elixir',
\ 'coc-eslint',
\ 'coc-fish',
\ 'coc-go',
\ 'coc-html',
\ 'coc-json',
\ 'coc-prettier',
\ 'coc-pyright',
\ 'coc-rust-analyzer',
\ 'coc-snippets',
\ 'coc-sql',
\ 'coc-tailwindcss',
\ 'coc-tsserver',
\ 'coc-vimtex',
\ ]

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" coc-snippets
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Jump to definition
nmap <silent> <C-]> <Plug>(coc-definition)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Fix (incl. add missing) Golang imports on save.
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Use K to show documentation in preview window
nnoremap <silent> K :call CocAction('doHover')<CR>
