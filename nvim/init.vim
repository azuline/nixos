" ===============
" === General ===
" ===============
set spellfile=~/.config/nvim/spell/en.utf-8.add

" These need to be configured before we load plugins.
let g:polyglot_disabled=['markdown']
let g:markdown_enable_conceal=1

" Setting Coq colors, needs to be configured before we load the plugin.
augroup CoqtailHighlights
  autocmd!
  autocmd ColorScheme *
    \   hi def CoqtailChecked ctermbg=236 guibg=#292D3E
    \ | hi def CoqtailSent    ctermbg=236 guibg=#292D3E
    \ | hi def link CoqtailError Error
augroup END

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
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" Visuals
" -------

" Color scheme
Plug 'drewtempelmeyer/palenight.vim'

" Status line
Plug 'itchyny/lightline.vim'
Plug 'spywhere/lightline-lsp'
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

" Coq
Plug 'whonore/Coqtail'

" Markdown
Plug 'gabrielelana/vim-markdown'

" Bullet points, because the replacement Markdown plugins all suck
Plug 'dkarter/bullets.vim'

" LaTeX!
Plug 'lervag/vimtex', {'tag': 'v1.6'}
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

" Editing Augmentation
" --------------------

" LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'
Plug 'simrat39/rust-tools.nvim'

" Funnel LSP through null-ls
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" Snippets to stop nvim-cmp from crashing.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

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

call plug#end()

" ==================
" === STATUSLINE ===
" ==================
" IMPORTANT: This section must be loaded before Palenight theme section.

set laststatus=2
set noshowmode

lua <<EOF
vim.g["lightline"] = {
  colorscheme = "palenight",
  separator = { 
    left = '', 
    right = '',
  },
  subseparator = {
    left = '',
    right = '',
  },
  tabline = {
    left = {{'buffers'}},
  },
  component_expand = {
    linter_hints = 'lightline#lsp#hints',
    linter_infos = 'lightline#lsp#infos',
    linter_warnings = 'lightline#lsp#warnings',
    linter_errors = 'lightline#lsp#errors',
    linter_ok = 'lightline#lsp#ok',
    buffers = 'lightline#bufferline#buffers',
  },
  component_type = {
    linter_checking = 'right',
    linter_infos = 'right',
    linter_warnings = 'warning',
    linter_errors = 'error',
    linter_ok = 'right',
    buffers = 'tabsel',
  },
  active = {
    left = {
      {'mode', 'paste'},
      {'readonly', 'filename', 'modified', 'helloworld'},
    },
    right = {
      {'lineinfo'},
      {'percent'},
      {'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'},
      {'fileformat', 'fileencoding', 'filetype'},
    },
  },
}
EOF

" ===================
" === APPEARANCE  ===
" ===================

" === Multiple Cursors
" The vim multi cursors are invisible in default theme.
let g:VM_theme = 'nord'

" === Highlight on Yank
lua <<EOF
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]
EOF

" === Theme Fixes
" Fix terminal colors for Palenight
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
" Enable italics
let g:palenight_terminal_italics=1
" The grays in palenight are too dark.
let g:palenight_color_overrides = {
  \   'gutter_fg_grey': { 'gui': '#657291', 'cterm': '245', 'cterm16': '15' },
  \   'comment_grey': { 'gui': '#7272a8', 'cterm': '247', 'cterm16': '15' },
  \ }
" Set the background.
set background=dark
colorscheme palenight
hi Normal guibg=NONE ctermbg=NONE

" === Git gutter configurations.
" Always keep signcolumn on.
set signcolumn=yes
" Modify signify delete color.
highlight SignifySignDelete ctermfg=204 guifg=#ff869a cterm=NONE gui=NONE

" === LaTeX configuration.
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

" ================
" === BEHAVIOR ===
" ================

" === Bullet Behavior
" Selectively enable bullets for these filetypes.
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" === Vim-test Keybinds
nmap <silent> <Leader>tn :TestNearest<CR>
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>ts :TestSuite<CR>
nmap <silent> <Leader>tl :TestLast<CR>
nmap <silent> <Leader>tg :TestVisit<CR>

" === Quickfix augmentations
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

" ===========================
" === SYNTAX HIGHLIGHTING ===
" ===========================

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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

" ========================
" === FILE NAVIGATION  ===
" ========================

" === Tree browser
nnoremap <Leader>f <Cmd>CHADopen<CR>
nnoremap <Leader>c <Cmd>call setqflist([])<CR>
lua <<EOF
local chadtree_settings = { 
  ignore = {
    name_exact = {
      ".DS_Store",
      ".directory",
      "thumbs.db",
      ".git",
      "node_modules",
      "__pycache__",
      "build",
      "dist",
    },
  },
  -- Eh, this doesn't work with native theme, but nord looks alright.
  theme = {
    text_colour_set = "nord";
  },
  view = {
    window_options = {
      number = true,
      relativenumber = true,
    },
  },
}
vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
EOF

" === Fuzzy File Finder
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

" === Tab Bar
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

" ==================
" === LSP CONFIG ===
" ==================

lua <<EOF
local lspconfig = require('lspconfig')
local null_ls = require('null-ls')

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
      silent = true,
  })
end

local on_attach = function(client, bufnr)
  vim.cmd('command! LspDef lua vim.lsp.buf.definition({ includeDeclaration = false })')
  vim.cmd('command! LspFormatting lua vim.lsp.buf.formatting()')
  vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
  vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
  vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
  vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
  vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
  vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
  vim.cmd('command! LspDiagPrev lua vim.diagnostic.goto_prev()')
  vim.cmd('command! LspDiagNext lua vim.diagnostic.goto_next()')
  vim.cmd('command! LspDiagLine lua vim.diagnostic.open_float()')
  vim.cmd('command! LspSignatureHelp lua vim.lsp.buf.signature_help()')

  buf_map(bufnr, 'n', '<Leader>rn', ':LspRename<CR>')
  buf_map(bufnr, 'n', 'K', ':LspHover<CR>')
  buf_map(bufnr, 'n', '[g', ':LspDiagPrev<CR>')
  buf_map(bufnr, 'n', ']g', ':LspDiagNext<CR>')
  buf_map(bufnr, 'n', '<Leader>a', ':LspCodeAction<CR>')
  buf_map(bufnr, 'n', '<C-]>', ':LspDef<CR>')

  if client.resolved_capabilities.document_formatting then
    vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()')
  end
end

-- To avoid react.d.ts definitions from opening on jump to definition.
-- https://github.com/typescript-language-server/typescript-language-server/issues/216#issuecomment-1005272952
local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  
  settings = {
    gopls = {
      gofumpt = false,
      usePlaceholders = true,
      -- TODO: Put this into a Pipe-specific config
      ["local"] = "github.com/pipe-technologies/pipe/backend",
    },
  },
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ['textDocument/definition'] = vim.lsp.handlers['textDocument/definition'],
  },
}

lspconfig.hls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = {
    ['textDocument/definition'] = vim.lsp.handlers['textDocument/definition'],
  },
}

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    local ts_utils = require('nvim-lsp-ts-utils')
    ts_utils.setup {
      update_imports_on_move = true,
    }
    ts_utils.setup_client(client)
    buf_map(bufnr, 'n', '<Leader>i', ':TSLspImportAll<CR>')
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  handlers = {
    ['textDocument/definition'] = function(err, result, method, ...)
      local function filterDTS(value)
        return string.match(value.uri, '.d.ts') == nil
      end

      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterDTS)
        return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
    end,
  }
}

null_ls.setup {
  root_dir = lspconfig.util.root_pattern(".null-ls-root", "Makefile", "tsconfig.json", "go.mod", "poetry.toml", ".git"),
  sources = {
    null_ls.builtins.diagnostics.semgrep,
    -- JS/TS/JSX/TSX
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
      },
    }),
    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.flake8,
    -- Golang
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,
    -- null_ls.builtins.diagnostics.revive,
    -- Nix
    null_ls.builtins.formatting.nixpkgs_fmt,
    -- Postgres
    null_ls.builtins.formatting.pg_format,
    -- Rust
    null_ls.builtins.formatting.rustfmt,
    -- Bash
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.code_actions.shellcheck,
  },
  on_attach = on_attach,
}
EOF

" ======================
" === AUTOCOMPLETION ===
" ======================

set completeopt=menu,menuone,noselect

lua <<EOF
-- Setup nvim-cmp.
local cmp = require('cmp')
local lspkind = require('lspkind')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer', keyword_length = 3 },
  }),
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[lsp]",
        path = "[path]",
        latex_symbols = "[latex]",
      },
    },
  },
  experimental = {
    ghost_text = true,
  },
  view = {
    entries = "native",
  },
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
    end
  end
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'buffer', keyword_length = 3 }
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path', keyword_length = 3 }
  }, {
    { name = 'cmdline', keyword_length = 3 }
  })
})
EOF
