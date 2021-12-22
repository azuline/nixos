" ===============
" === General ===
" ===============
set spellfile=~/.config/nvim/spell/en.utf-8.add

" These need to be configured before we load plugins.
let g:polyglot_disabled=['markdown']
let g:markdown_enable_conceal=1
" let g:ale_disable_lsp=1

" Setting Coq colors, needs to be configured before we load the plugin.
augroup CoqtailHighlights
  autocmd!
  autocmd ColorScheme *
    \   hi def CoqtailChecked ctermbg=236 guibg=#292D3E
    \ | hi def CoqtailSent    ctermbg=236 guibg=#292D3E
    \ | hi def link CoqtailError Error
augroup END

" Table of Contents. Search symbol to jump!

" PLUGINS
" FERN
" FZF
" LIGHTLINE
" PALENIGHT
" ALE
" COC
" GITGUTTER
" LATEX
" WIKI
" BULLETS
" YANKHIGHLIGHT
" GOLANG
" QUICKSCOPE
" TESTRUNNER
" TERMINAL
" QUICKFIX

" ===============
" === PLUGINS ===
" ===============

" Perhaps one day I will be sane and cherry-pick things from these plugins
" that I need while forgoing the remaining bloat. However, right now, I'm
" lazy, my computer is fast, and I don't want to devote the time.
call plug#begin(stdpath('data').'/plugged')

" Navigation
" ----------

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File system explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
" https://github.com/lambdalisue/fern.vim/issues/120
Plug 'antoinemadec/FixCursorHold.nvim'

" Visuals
" -------

" Color scheme
Plug 'drewtempelmeyer/palenight.vim'

" Status line
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'
Plug 'mengelbrecht/lightline-bufferline'

" Git gutter
Plug 'mhinz/vim-signify'

" Extra file context
" This plays poorly with Fern.
" Plug 'wellle/context.vim'

" Language/Syntax Plugins
" -----------------------

" Language parser & highlighting
" We use polyglot for indentation, since tree-sitter is not mature.
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Golang
Plug 'fatih/vim-go'

" Coq
Plug 'whonore/Coqtail'

" Markdown
Plug 'gabrielelana/vim-markdown'

" Bullet points, because the replacement Markdown plugins all suck
Plug 'dkarter/bullets.vim'

" LaTeX!
Plug 'lervag/vimtex', {'tag': 'v1.6'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

" Extra snippets
Plug 'honza/vim-snippets'

" Editing Augmentation
" --------------------

" Linter and fixer
Plug 'dense-analysis/ale'

" LSP client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Comment/uncomment assistance (because I'm slow)
Plug 'tpope/vim-commentary'

" Pluralization & case coercion
Plug 'tpope/vim-abolish'

" Extra text objects
Plug 'wellle/targets.vim'

" Surrounding objects mutation
Plug 'tpope/vim-surround'

" Text alignment operator
Plug 'tommcdo/vim-lion'

" Repeat for plugins
Plug 'tpope/vim-repeat'

" Sublime style multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Highlight `f/F` Letters
Plug 'unblevable/quick-scope'

" Highlight yanked region
Plug 'machakann/vim-highlightedyank'

" Color highlighting.
Plug 'ap/vim-css-color'

" Integrations
" ------------
" Git Client
Plug 'tpope/vim-fugitive'
" Git History Viewer
Plug 'junegunn/gv.vim'
" Test Runner
Plug 'vim-test/vim-test'
" A personal wiki!
Plug 'lervag/wiki.vim'

call plug#end()

" ==================
" === TREESITTER ===
" ==================

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1019#issuecomment-811658387
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = false,
  }
}
EOF

" ============
" === FERN ===
" ============

nnoremap <Leader>f :Fern . -drawer -toggle -width=30 -reveal=%<CR>

let g:fern_git_status#disable_ignored = 1
let g:fern#renderer = "nerdfont"
let g:fern#disable_default_mappings = 1

let g:fern#default_hidden = 1
let g:fern#default_exclude = '^\%(\.git\|__pycache__\|\.mypy_cache\|\.pytest_cache\|htmlcov\|repertoire\.egg-info\|\.coverage\|node_modules\|build\)$'

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> o <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> l <Plug>(fern-action-expand)
  nmap <buffer> h <Plug>(fern-action-collapse)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> d <Plug>(fern-action-remove)
  nmap <buffer> c <Plug>(fern-action-copy)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> H <Plug>(fern-action-hidden-toggle)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> <C-j> <Plug>(fern-action-mark:toggle)j
  nmap <buffer> <C-k> <Plug>(fern-action-mark:toggle)k
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

" ===========
" === FZF ===
" ===========

" Git Files
nnoremap <Leader>. :GitFiles! --cached --others --exclude-standard<CR>
" Ripgrep
nnoremap <Leader>g :Rg!<CR>
" Command All
nnoremap <Leader>ca :Commands!<CR>
" Command History
nnoremap <Leader>ch :History:!<CR>
" History File
nnoremap <Leader>hf :GV!<CR>
" History All
nnoremap <Leader>ha :GV<CR>

" Configure FZF preview window.
let g:fzf_preview_window=['up:40%:hidden', 'ctrl-/']

" =================
" === LIGHTLINE ===
" =================
" IMPORTANT: This section must be loaded before Palenight theme section.

set laststatus=2
set noshowmode

let g:lightline={
  \   'colorscheme': 'palenight',
  \   'separator': { 'left': '', 'right': '' },
  \   'subseparator': { 'left': '', 'right': '' },
  \   'component_expand': {
  \     'linter_checking': 'lightline#ale#checking',
  \     'linter_infos': 'lightline#ale#infos',
  \     'linter_warnings': 'lightline#ale#warnings',
  \     'linter_errors': 'lightline#ale#errors',
  \     'linter_ok': 'lightline#ale#ok',
  \     'buffers': 'lightline#bufferline#buffers',
  \   },
  \   'component_type': {
  \     'linter_checking': 'right',
  \     'linter_infos': 'right',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'right',
  \     'buffers': 'tabsel',
  \   },
  \   'active': {
  \     'left': [
  \       ['mode', 'paste'],
  \       ['readonly', 'filename', 'modified', 'helloworld'],
  \       ['coc_status'],
  \     ],
  \     'right': [
  \       ['lineinfo'],
  \       ['percent'],
  \       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
  \       ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok'],
  \       ['fileformat', 'fileencoding', 'filetype'],
  \     ],
  \   },
  \   'tabline': {
  \     'left': [
  \       ['buffers'],
  \     ],
  \   },
  \ }
call lightline#coc#register()

" Switch to buffer.
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" Delete buffer.
nmap <Leader>d1 <Plug>lightline#bufferline#delete(1)
nmap <Leader>d2 <Plug>lightline#bufferline#delete(2)
nmap <Leader>d3 <Plug>lightline#bufferline#delete(3)
nmap <Leader>d4 <Plug>lightline#bufferline#delete(4)
nmap <Leader>d5 <Plug>lightline#bufferline#delete(5)
nmap <Leader>d6 <Plug>lightline#bufferline#delete(6)
nmap <Leader>d7 <Plug>lightline#bufferline#delete(7)
nmap <Leader>d8 <Plug>lightline#bufferline#delete(8)
nmap <Leader>d9 <Plug>lightline#bufferline#delete(9)
nmap <Leader>d0 <Plug>lightline#bufferline#delete(10)

let g:lightline#bufferline#show_number=2
let g:lightline#bufferline#min_buffer_count=2

" =================
" === PALENIGHT ===
" =================

" Fix terminal colors for Palenight
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" The grays in palenight are too dark.
let g:palenight_color_overrides = {
  \   'gutter_fg_grey': { 'gui': '#657291', 'cterm': '245', 'cterm16': '15' },
  \   'comment_grey': { 'gui': '#7272a8', 'cterm': '247', 'cterm16': '15' },
  \ }

" Set the background.
set background=dark
colorscheme palenight
hi Normal guibg=NONE ctermbg=NONE

" ===========
" === ALE ===
" ===========

let g:ale_linters_explicit=1
let g:ale_fix_on_save=1

let g:ale_linters={
  \ 'haskell': [],
  \ 'cpp': ['clang-tidy'],
  \ 'sql': ['sqlint'],
  \ }

let g:ale_fixers={
  \ '*': [],
  \ 'python': ['isort'],
  \ }

for lang in keys(g:ale_fixers)
  let g:ale_fixers[lang] = g:ale_fixers[lang] + ['remove_trailing_lines', 'trim_whitespace']
endfor

" ===========
" === COC ===
" ===========

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

" =================
" === GITGUTTER ===
" =================

" Always keep signcolumn on.
set signcolumn=yes
" Modify signify delete color.
highlight SignifySignDelete ctermfg=204 guifg=#ff869a cterm=NONE gui=NONE

" =============
" === LATEX ===
" =============

" Configure some LaTeX behaviors.
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_general_viewer='evince'
" For vim-conceal.
set conceallevel=2
let g:tex_conceal='abdmg'
let g:tex_conceal_frac=1
" Extra conceal matches.
syntax match textCmdStyleBold '\\mathbf\>\s*' skipwhite skipnl nextgroup=texStyleBold conceal

" ============
" === WIKI ===
" ============

" Configure vim-wiki keybinds.
nnoremap ]w :WikiLinkNext<CR>
nnoremap [w :WikiLinkPrev<CR>
" Configure vim-wiki options.
let g:wiki_root='~/notes'
let g:wiki_filetypes=['md', 'markdown']

" ===============
" === BULLETS ===
" ===============

" Selectively enable bullets for these filetypes.
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" =====================
" === YANKHIGHLIGHT ===
" =====================

" Lower the duration of the yank highlight.
let g:highlightedyank_highlight_duration = 200

" ==============
" === Golang ===
" ==============

" vim-go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
" Auto formatting and importing
let g:go_fmt_autosave = 0
" Status line types/signatures
let g:go_auto_type_info = 1

" ==================
" === QUICKSCOPE ===
" ==================

" Underline quickscope letters instead of changing the color.
augroup QuickScopeColors
  autocmd ColorScheme * highlight QuickScopePrimary gui=underline cterm=underline
augroup end
" Disable quickscope in Fern.
augroup FernQuickScope
  au FileType fern let b:qs_local_disable=1
augroup end

" Multiple Cursors
" The vim multi cursors are invisible in default theme.
let g:VM_theme = 'nord'

" ==================
" === TESTRUNNER ===
" ==================

" Additional vim-test keybinds.
nmap <silent> <Leader>tn :TestNearest<CR>
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ts :TestSuite<CR>
nmap <silent> <Leader>tl :TestLast<CR>
nmap <silent> <Leader>tg :TestVisit<CR>

function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> <Leader>td :call DebugNearest()<CR>

" ================
" === TERMINAL ===
" ================

" Terminal keybinds
nnoremap <Leader><CR> :terminal<CR>
" Map Esc to terminal's Esc
au TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
au FileType fzf tunmap <buffer> <Esc>

" ================
" === QUICKFIX ===
" ================

" Custom open quickfix list hotkey.
nmap <Leader>ea :call OpenQuickfixList()<CR>
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
