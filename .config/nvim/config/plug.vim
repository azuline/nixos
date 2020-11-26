" Plugin Loader
" =============

call plug#begin(stdpath('data') . '/plugged')

" Core Plugins
" ------------

" Syntax Highlighting
Plug 'sheerun/vim-polyglot'
" Linter and Fixer
Plug 'dense-analysis/ale'
" LSP Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Status Bar
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'
" File System Explorer
Plug 'preservim/nerdtree'
" Palenight Theme
Plug 'drewtempelmeyer/palenight.vim'

" Other Plugins
" -------------

" Extra snippets
Plug 'honza/vim-snippets'
" Comment/Uncomment Assistance (because I'm slow)
Plug 'tpope/vim-commentary'
" Highlight `f/F` Letters
Plug 'unblevable/quick-scope'
" Git Client
Plug 'tpope/vim-fugitive'
" Git History Viewer
Plug 'junegunn/gv.vim'
" Git Gutter
" Plug 'airblade/vim-gitgutter'
" Live Markdown Previewer.
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" Live LaTeX Previewer.
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()

" Miscellaneous Plugin Configuration
" ==================================

" FZF
" ---

let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" Markdown Preview
" ----------------

let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex Live Preview
" ------------------

let g:livepreview_cursorhold_recompile=0

" NERDTree
" --------

let NERDTreeIgnore = ['build', 'node_modules', '__pycache__', '\.egg-info$', '\.pyc$', '\.o$']
let NERDTreeShowHidden=1

" Hack to disable lightline in NERDTree.
" https://vi.stackexchange.com/a/22414
augroup filetype_nerdtree
  au!
  au FileType nerdtree call s:disable_lightline_on_nerdtree()
  au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_nerdtree()
augroup END

fu s:disable_lightline_on_nerdtree() abort
 let nerdtree_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'nerdtree') + 1
 call timer_start(0, {-> nerdtree_winnr && setwinvar(nerdtree_winnr, '&stl', '%#Normal#')})
endfu

" Close Vim if only NERDTree is left.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
