" Load packages

" I am leaving comments describing each one, for maintenance purposes.

" Auto-linter/formatter integrations.
packadd ale

" Integration for fzf. A lot of FZF commands are bound to `<Leader>{key}` for
" navigating around the filesystem and whatnot.
packadd fzf
packadd fzf.vim

" Lightweight status bar.
packadd lightline.vim
" Displays ALE warnings in the status bar.
packadd lightline-ale

" Previewing markdown files in browser.
" - :MarkdownPreview | open current markdown file in browser.
packadd markdown-preview.nvim

" NERDTree - Tree explorer.
" Mapped <Leader>t to open NERDTree
" Commands:
" - Open | o/i/s
" - Close | x
" - Create/move/delete | m
packadd nerdtree

" Highlights characters on the same line for `f/F` quick jumping.
packadd quick-scope

" Plugin to make commenting code out easier.
" Commands:
" - gcc | comments out a line
" - gc | comments out lines
" - gcap | comment out a paragraph :O
" - You can also use it as a command, either with a range like
"   :7,17Commentary, or as part of a :global invocation like with
"   :g/pattern/Commentary. That's it.
packadd vim-commentary

" Git wrapper.
packadd vim-fugitive

" Git status left of the line numbers.
packadd vim-gitgutter

" Live preview latex files!
" Commands:
"   - :LLPStartPreview | open current latex file in evince.
packadd vim-latex-live-preview

" Work with surrounding parentheses/brackets/quotes/whatever
" Comands:
" - csXY | replace surrounding X with Y
packadd vim-surround

" Language syntax highlighting.
packadd vim-polyglot

" Spell file
set spellfile=~/.vim/spell/en.utf-8.add

" Key mappings

" Builtin Vim stuff
set pastetoggle=<F2>
nnoremap <Leader>p <F2>
" FZF commands
nnoremap <Leader>. :GitFiles! --cached --others --exclude-standard<CR>
nnoremap <Leader>f :Files!<CR>
nnoremap <Leader>g :Rg!<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>l :Lines!<CR>
nnoremap <Leader>r :History!<CR>
nnoremap <Leader>c :Commands!<CR>
nnoremap <Leader>C :History:!<CR>
nnoremap <Leader>h :BCommits!<CR>
nnoremap <Leader>H :Commits!<CR>
" NERDTree
nnoremap <Leader>t :NERDTreeToggleVCS<CR>
nnoremap <Leader>T :NERDTreeFind<CR>

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
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['eslint', 'tsserver'],
\ 'typescriptreact': ['eslint', 'tsserver'],
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
\ 'typescript': ['prettier'],
\ 'typescriptreact': ['prettier'],
\ 'json': ['prettier'],
\ 'ruby': ['rubocop'],
\ 'ocaml': ['ocamlformat', 'ocp-indent'],
\ 'haskell': ['stylish-haskell'],
\ 'html': ['prettier'],
\ }

" Because ALE is not adding this to every file type.
for lang in keys(g:ale_fixers)
    let g:ale_fixers[lang] = g:ale_fixers[lang] + ['remove_trailing_lines', 'trim_whitespace']
endfor

let g:ale_fix_on_save=1
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=0

let g:ale_rust_cargo_use_clippy=1

" ALE colors
highlight ALEErrorSign ctermbg=3

" Gitgutter
highlight! link SignColumn LineNr
let g:gitgutter_set_sign_backgrounds = 1
highlight GitGutterAdd    ctermfg=2 ctermbg=NONE
highlight GitGutterChange ctermfg=3 ctermbg=NONE
highlight GitGutterDelete ctermfg=1 ctermbg=NONE

" Markdown Preview
let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
let g:livepreview_cursorhold_recompile=0

" NERDTree
" Ignore artifacts.
let NERDTreeIgnore = ['build', 'node_modules', '__pycache__', '\.egg-info$', '\.pyc$', '\.o$']
" Show hidden by default.
let NERDTreeShowHidden=1
" Single click mouse in NERDTree.
let NERDTreeMouseMode=3

" Lightline
set laststatus=2
set noshowmode

let g:lightline={
\   'component_expand': {
\     'linter_checking': 'lightline#ale#checking',
\     'linter_infos': 'lightline#ale#infos',
\     'linter_warnings': 'lightline#ale#warnings',
\     'linter_errors': 'lightline#ale#errors',
\     'linter_ok': 'lightline#ale#ok'
\   },
\   'component_type': {
\     'linter_checking': 'right',
\     'linter_infos': 'right',
\     'linter_warnings': 'warning',
\     'linter_errors': 'error',
\     'linter_ok': 'right'
\   },
\   'active': {
\     'right': [
\       [ 'lineinfo' ],
\       [ 'percent' ],
\       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
\       [ 'fileformat', 'fileencoding', 'filetype' ]
\     ]
\   }
\ }
