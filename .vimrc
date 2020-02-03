" Linting
let g:ale_linters={
\ 'python': ['flake8'],
\ 'rust': ['cargo'],
\ 'elixir': ['mix'],
\ }

let g:ale_fixers={
\ 'python': ['isort'],
\ 'rust': ['rustfmt'],
\ 'markdown': ['prettier'],
\ 'css': ['prettier'],
\ 'scss': ['prettier'],
\ 'javascript': ['prettier'],
\ 'json': ['prettier'],
\ 'elixir': ['mix_format'],
\ 'ruby': ['rubocop'],
\ }

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" Python-specific linting
let python_highlight_all = 1
let g:black_linelength = 79
let g:black_skip_string_normalization = 1
" autocmd BufWritePre *.py execute ':Black'

" Java highlighting
let java_highlight_java_lang_ids = 1
let java_highlight_functions = 'style'
let java_highlight_debug = 1
let java_minlines = 25

" Python autocompletion
autocmd FileType python let b:vcm_tab_complete = 'python'

" MarkdownPreview
let g:mkdp_browser='firefox'
let g:mkdp_highlight_css='~/.vim/markdown_preview.css'
let g:mkdp_port='7237'

" Latex
let g:livepreview_cursorhold_recompile = 0

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
\ 'active': {
\   'right': [ [ 'lineinfo' ], [ 'percent', 'wordcount' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_function': {
\   'wordcount': 'WordCount',
\ },
\ }

function! WordCount()
    let currentmode = mode()
    if !exists("g:lastmode_wc")
        let g:lastmode_wc = currentmode
    endif
    " if we modify file, open a new buffer, be in visual ever, or switch modes
    " since last run, we recompute.
    if &modified || !exists("b:wordcount") || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc
        let g:lastmode_wc = currentmode
        let l:old_position = getpos('.')
        let l:old_status = v:statusmsg
        execute "silent normal g\<c-g>"
        if v:statusmsg == "--No lines in buffer--"
            let b:wordcount = 0
        else
            let s:split_wc = split(v:statusmsg)
            if index(s:split_wc, "Selected") < 0
                let b:wordcount = str2nr(s:split_wc[11])
            else
                let b:wordcount = str2nr(s:split_wc[5])
            endif
            let v:statusmsg = l:old_status
        endif
        call setpos('.', l:old_position)
        return b:wordcount
    else
        return b:wordcount
    endif
endfunction
