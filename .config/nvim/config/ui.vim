" User Interface Configuration
" ============================
"
" We have:
" - a statusline (lightline)
" - a custom theme (palenight)
" - a git gutter (gitgutter)

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

" Gitgutter
highlight! link SignColumn LineNr
