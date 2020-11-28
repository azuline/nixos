" User Interface Configuration
" ============================
"
" We have:
" - a statusline (lightline)
" - a custom theme (palenight)
" - a git gutter (signify)
" - a filesystem explorer (nerdtree)

" Lightline
" ---------
"
" IMPORTANT: This section must be loaded before Palenight theme section.

set laststatus=2
set noshowmode

let g:lightline={
  \   'colorscheme': 'palenight',
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
  \     'left': [
  \       ['mode', 'paste'],
  \       ['readonly', 'filename', 'modified', 'helloworld'],
  \       ['coc_status']
  \     ],
  \     'right': [
  \       ['lineinfo'],
  \       ['percent'],
  \       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
  \       ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok'],
  \       ['fileformat', 'fileencoding', 'filetype'],
  \     ]
  \   }
  \ }
call lightline#coc#register()

" Palenight Theme
" ---------------

let g:palenight_color_overrides = {
  \   'gutter_fg_grey': { 'gui': '#657291', 'cterm': '245', 'cterm16': '15' },
  \   'comment_grey': { 'gui': '#7272a8', 'cterm': '247', 'cterm16': '15' },
  \ }

set background=dark
colorscheme palenight
hi Normal guibg=NONE ctermbg=NONE

" Signify
" -------

highlight SignifySignDelete ctermfg=204 guifg=#ff869a cterm=NONE gui=NONE

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
