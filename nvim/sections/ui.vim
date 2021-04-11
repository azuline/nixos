" User Interface Configuration
" ============================
"
" We have:
" - a statusline (lightline)
" - a custom theme (palenight)
" - a git gutter (signify)
" - a filesystem explorer (nerdtree)
" - active text highlighter (limelight)

" Lightline
" ---------
"
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

let g:lightline#bufferline#show_number=2
let g:lightline#bufferline#min_buffer_count=2

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

" Fern
" ----

let g:fern_git_status#disable_ignored = 1
let g:fern#renderer = "nerdfont"
let g:fern#disable_default_mappings = 1

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

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

" Hack to disable Lightline
" https://vi.stackexchange.com/a/22414
augroup FernTypeGroup
    au FileType fern call s:disable_lightline_on_fern()
    au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_fern()
augroup END

function s:disable_lightline_on_fern() abort
 let fern_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'fern') + 1
 call timer_start(0, {-> fern_winnr && setwinvar(fern_winnr, '&stl', '%#Normal#')})
endfunction
