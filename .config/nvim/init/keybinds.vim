" Key Bindings
" ============

" Builtin Vim stuff
" -----------------
set pastetoggle=<F2>
nnoremap <Leader>p <F2>

" vim-go stuff
" ------------
nnoremap gt :GoTestFunc<CR>

" FZF commands
" ------------
nnoremap <Leader>. :GitFiles! --cached --others --exclude-standard<CR>
nnoremap <Leader>f :Files!<CR>
nnoremap <Leader>g :Rg!<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>c :Commands!<CR>
nnoremap <Leader>C :History:!<CR>
nnoremap <Leader>h :GV!<CR>
nnoremap <Leader>H :GV<CR>
nnoremap <Leader>l :Limelight!!<CR>

" NERDTree
" --------
nnoremap <Leader>t :NERDTreeToggleVCS<CR>
nnoremap <Leader>T :NERDTreeFind<CR>

" Terminal
" --------
nnoremap <Leader><CR> :terminal<CR>
" Map Esc to terminal's Esc
tnoremap <Esc> <C-\><C-n>

" Wiki
" ----
nnoremap ]w :WikiLinkNext<CR>
nnoremap [w :WikiLinkPrev<CR>

" Spellcheck
" ----------
" Bind <C-w> to automatically correct the previous word in insert & normal mode.
inoremap <C-w> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <C-w> i<c-g>u<Esc>[s1z=`]a<c-g>u<Esc>

" Lightline
" ---------
" Manage buffers via lightline.

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
