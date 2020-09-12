source /usr/share/vim/vimrc

" Load packages
packadd ale
packadd fzf
packadd fzf.vim
packadd lightline
" packadd lightline-ale
packadd markdown-preview.nvim
packadd quick-scope
packadd rust.vim
packadd vim-commentary
" packadd VimCompletesMe
packadd vim-elixir
packadd vim-elm-syntax
packadd vim-fugitive
packadd vim-latex-live-preview
packadd vim-python-pep8-indent
packadd vim-racket
packadd vim-jsx-pretty
packadd vim-js

" Colorscheme
colorscheme ron

" Spell file
set spellfile=~/.vim/spell/en.utf-8.add

" Key mappings

nnoremap <Leader>. :GitFiles<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>F :Files<Space>
nnoremap <Leader>g :Rg<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>r :History<CR>
nnoremap <Leader>h :History:<CR>
nnoremap <Leader>c :Commands<CR>
nnoremap <Leader>t :BTags<CR>
nnoremap <Leader>T :Tags<CR>

" Swap files
:set directory=$HOME/.vim/swap/

" Linting
let g:ale_linters={
\ 'python': ['flake8'],
\ 'elixir': ['credo'],
\ 'rust': ['cargo'],
\ 'c': ['clangtidy'],
\ 'tex': ['lacheck'],
\ 'haskell': ['hlint'],
\ 'javascript': ['flow', 'eslint'],
\ 'javascriptreact': ['flow', 'eslint'],
\ 'scss': [],
\ }

let g:ale_fixers={
\ '*': [],
\ 'python': ['isort', 'black'],
\ 'rust': ['rustfmt'],
\ 'c': ['clang-format'],
\ 'elixir': ['mix_format'],
\ 'markdown': ['prettier'],
\ 'css': ['prettier'],
\ 'scss': ['prettier'],
\ 'javascript': ['prettier'],
\ 'javascriptreact': ['prettier'],
\ 'json': ['prettier'],
\ 'ruby': ['rubocop'],
\ 'ocaml': ['ocamlformat', 'ocp-indent'],
\ 'haskell': ['stylish-haskell'],
\ }

" Because ALE is not adding this to every file type.
for lang in keys(g:ale_fixers)
    let g:ale_fixers[lang] = g:ale_fixers[lang] + ['remove_trailing_lines', 'trim_whitespace']
endfor

let g:ale_fix_on_save=1
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=0

" let g:ale_python_black_options='--skip-string-normalization'
let g:ale_rust_cargo_use_clippy=1

" Highlighting
let java_highlight_java_lang_ids=1
let java_highlight_functions='style'
let java_highlight_debug=1
let java_minlines=25

" Markdown Preview
let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
let g:livepreview_cursorhold_recompile=0

" Lightline
set laststatus=2
set noshowmode

let g:lightline={}

let g:lightline.component_expand={
\ 'linter_checking': 'lightline#ale#checking',
\ 'linter_infos': 'lightline#ale#infos',
\ 'linter_warnings': 'lightline#ale#warnings',
\ 'linter_errors': 'lightline#ale#errors',
\ 'linter_ok': 'lightline#ale#ok',
\ }

let g:lightline.component_type={
\ 'linter_checking': 'right',
\ 'linter_infos': 'right',
\ 'linter_warnings': 'warning',
\ 'linter_errors': 'error',
\ 'linter_ok': 'right',
\ }

let g:lightline.active={
\ 'right': [
\   [ 'lineinfo' ],
\   [ 'percent' ],
\   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
\   [ 'fileformat', 'fileencoding', 'filetype' ]
\ ],
\ }
