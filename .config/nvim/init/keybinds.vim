" Key Bindings
" ============

" Builtin Vim stuff
" -----------------
set pastetoggle=<F2>
nnoremap <Leader>p <F2>

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
nnoremap <Leader>j :WikiJournal<CR>
nnoremap ]w :WikiLinkNext<CR>
nnoremap [w :WikiLinkPrev<CR>

" Spellcheck
" ----------
" Bind <C-l> to automatically correct the previous word in insert & normal mode.
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <C-l> i<c-g>u<Esc>[s1z=`]a<c-g>u<Esc>
