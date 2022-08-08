do -- Treesitter Configuration
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "javascript" }, -- List of parsers to ignore installing
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1019#issuecomment-811658387
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {}, -- list of language that will be disabled
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = false,
    },
    textsubjects = {
      enable = true,
      prev_selection = ",", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    },
  })
end

do -- LaTeX syntax stuffs
  -- Configure some LaTeX behaviors.
  vim.g.tex_flavor = "latex"
  vim.g.vimtex_quickfix_mode = 0
  vim.g.vimtex_view_general_viewer = "evince"
  -- For vim-conceal.
  vim.opt.conceallevel = 2
  vim.g.tex_conceal = "abdmg"
  vim.g.tex_conceal_frac = 1
  -- Extra conceal matches.
  vim.cmd('syntax match textCmdStyleBold "\\mathbf>s*" skipwhite skipnl nextgroup=texStyleBold conceal')
end

do -- Configure the statusbar.
  vim.opt.laststatus = 2
  vim.opt.showmode = false

  vim.g["lightline"] = {
    colorscheme = "palenight",
    separator = {
      left = "",
      right = "",
    },
    subseparator = {
      left = "",
      right = "",
    },
    tabline = {
      left = { { "buffers" } },
    },
    component_expand = {
      linter_hints = "lightline#lsp#hints",
      linter_infos = "lightline#lsp#infos",
      linter_warnings = "lightline#lsp#warnings",
      linter_errors = "lightline#lsp#errors",
      linter_ok = "lightline#lsp#ok",
      buffers = "lightline#bufferline#buffers",
    },
    component_type = {
      linter_checking = "right",
      linter_infos = "right",
      linter_warnings = "warning",
      linter_errors = "error",
      linter_ok = "right",
      buffers = "tabsel",
    },
    active = {
      left = {
        { "mode", "paste" },
        { "readonly", "filename", "modified", "helloworld" },
      },
      right = {
        { "lineinfo" },
        { "percent" },
        { "linter_checking", "linter_errors", "linter_warnings", "linter_infos", "linter_ok" },
        { "fileformat", "fileencoding", "filetype" },
      },
    },
  }
end

do -- Multiple Cursors
  -- The vim multi cursors are invisible in default theme.
  vim.g.VM_theme = "nord"
end

do -- Highlight on Yank
  vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
end

do -- Set up Palenight theme
  -- Theme Fixes
  vim.cmd([[
    if exists("+termguicolors")
      let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
  ]])

  -- Enable italics
  vim.g.palenight_terminal_italics = 1
  -- The grays in palenight are too dark.
  vim.g.palenight_color_overrides = {
    gutter_fg_grey = {
      gui = "#657291",
      cterm = "245",
      cterm16 = "15",
    },
    comment_grey = {
      gui = "#7272a8",
      cterm = "247",
      cterm16 = "15",
    },
  }

  -- Set the background.
  vim.opt.background = "dark"
  vim.cmd("colorscheme palenight")
  vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
end

do -- Git Gutter
  -- Always keep signcolumn on.
  vim.opt.signcolumn = "yes"
  -- Modify signify delete color.
  vim.cmd("highlight SignifySignDelete ctermfg=204 guifg=#ff869a cterm=NONE gui=NONE")
end
