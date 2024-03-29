do -- Tree browser
  vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>CHADopen<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>c", "<Cmd>call setqflist([])<CR>", { noremap = true })

  local ignore_name_exact = {
    ".DS_Store",
    ".directory",
    "thumbs.db",
    ".git",
    "node_modules",
    "__pycache__",
    "build",
    "dist",
    ".direnv",
    ".mypy_cache",
    ".ruff_cache",
    ".stfolder",
  }

  local ignore_name_glob = {
    ".null-ls*",
    ".coverage.*",
    "*.png",
    "*.jpg",
    -- LaTeX stuff
    "*.gen.tex",
    "*.gen.md",
    "*.pdf",
    "*.aux",
    "*.toc",
    "*.synctex*",
    "*.out",
    "*.fls",
    "*.4tc",
    "*.4ct",
    "*.dvi",
    "*.log",
    "*.lg",
    "*.tmp",
    "*.idv",
    "*.xref",
    "*.fdb_latexmk",
    -- Bibtex
    "*.bbl",
    "*.bcf",
    "*.blg",
    "*.run.xml",
    "*-SAVE-ERROR",
  }

  if string.find(vim.fn.getcwd(), "^/home/blissful/atelier") and not os.getenv("ATELIER_DEV") then
    table.insert(ignore_name_exact, "_lib")
    table.insert(ignore_name_exact, "_store")
    table.insert(ignore_name_exact, "_tool")
    table.insert(ignore_name_exact, ".envrc")
    table.insert(ignore_name_exact, ".fdignore")
    table.insert(ignore_name_exact, ".gitignore")
    table.insert(ignore_name_exact, "flake.lock")
    table.insert(ignore_name_exact, "flake.nix")
    table.insert(ignore_name_exact, ".root")
    table.insert(ignore_name_exact, "pyproject.toml")
    table.insert(ignore_name_exact, ".stignore")
    table.insert(ignore_name_glob, "*.html")
    table.insert(ignore_name_glob, "*.css")
    table.insert(ignore_name_glob, "*.log")
  end

  vim.g["chadtree_settings"] = {
    ignore = {
      name_exact = ignore_name_exact,
      name_glob = ignore_name_glob,
    },
    keymap = {
      -- Open/close
      primary = { "<Enter>", "<Tab>", "o" },
      collapse = { "<S-Tab>" },
      v_split = { "w" },
      h_split = { "W" },
      -- File manipulation
      new = { "a" },
      rename = { "r" },
      copy = { "p" },
      cut = { "x" },
      delete = { "d" },
      -- Navigate
      quit = { "q" },
      change_focus = { "c" },
      change_focus_up = { "C" },
      jump_to_current = { "J" },
      -- Change view
      filter = { "f" },
      clear_filter = { "F" },
      select = { "s" },
      clear_selection = { "S" },
      -- Extra action
      copy_name = { "y" },
      copy_relname = { "Y" },
    },
    options = {
      -- Causes too much lag in large monorepos.
      session = false,
      show_hidden = false,
    },
    view = {
      window_options = {
        number = true,
        relativenumber = true,
      },
    },
    -- For some reason, CHADtree doesn't pick up the theme by default, so we
    -- need to define colors by hand. Copy pasted from Palenight.
    theme = {
      icon_glyph_set = "ascii",
      discrete_colour_map = {
        black = "#292D3E",
        red = "#ff5370",
        green = "#C3E88D",
        yellow = "#ffcb6b",
        blue = "#82b1ff",
        magenta = "#939ede",
        cyan = "#89DDFF",
        white = "#bfc7d5",
        bright_black = "#4B5263", -- gutter_fg_grey
        bright_red = "#ff869a", -- light_red
        bright_green = "#69ff94", -- dracula
        bright_yellow = "#ffffa5", -- dracula
        bright_blue = "#d6acff", -- dracula
        bright_magenta = "#ff92df", -- dracula
        bright_cyan = "#a4ffff", -- dracula
        bright_white = "#ffffff", -- white
      },
    },
  }
end

do -- Fuzzy File Finder
  -- Git Files
  vim.api.nvim_set_keymap("n", "<Leader>.", "<Cmd>GFiles! --cached --others --exclude-standard<CR>", { noremap = true })
  -- Ripgrep
  vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>Rg!<CR>", { noremap = true })
  -- Command All
  vim.api.nvim_set_keymap("n", "<Leader>ca", "<Cmd>Commands!<CR>", { noremap = true })
  -- Command History
  vim.api.nvim_set_keymap("n", "<Leader>ch", "<Cmd>History:!<CR>", { noremap = true })
  -- Configure FZF preview window.
  vim.g.fzf_preview_window = { "up:40%:hidden", "ctrl-/" }
end

do -- Tab Bar
  vim.api.nvim_set_keymap("n", "<Leader>1", "<Plug>lightline#bufferline#go(1)", {})
  vim.api.nvim_set_keymap("n", "<Leader>2", "<Plug>lightline#bufferline#go(2)", {})
  vim.api.nvim_set_keymap("n", "<Leader>3", "<Plug>lightline#bufferline#go(3)", {})
  vim.api.nvim_set_keymap("n", "<Leader>4", "<Plug>lightline#bufferline#go(4)", {})
  vim.api.nvim_set_keymap("n", "<Leader>5", "<Plug>lightline#bufferline#go(5)", {})
  vim.api.nvim_set_keymap("n", "<Leader>6", "<Plug>lightline#bufferline#go(6)", {})
  vim.api.nvim_set_keymap("n", "<Leader>7", "<Plug>lightline#bufferline#go(7)", {})
  vim.api.nvim_set_keymap("n", "<Leader>8", "<Plug>lightline#bufferline#go(8)", {})
  vim.api.nvim_set_keymap("n", "<Leader>9", "<Plug>lightline#bufferline#go(9)", {})
  vim.api.nvim_set_keymap("n", "<Leader>0", "<Plug>lightline#bufferline#go(10)", {})

  vim.api.nvim_set_keymap("n", "<Leader>d1", "<Plug>lightline#bufferline#delete(1)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d2", "<Plug>lightline#bufferline#delete(2)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d3", "<Plug>lightline#bufferline#delete(3)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d4", "<Plug>lightline#bufferline#delete(4)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d5", "<Plug>lightline#bufferline#delete(5)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d6", "<Plug>lightline#bufferline#delete(6)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d7", "<Plug>lightline#bufferline#delete(7)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d8", "<Plug>lightline#bufferline#delete(8)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d9", "<Plug>lightline#bufferline#delete(9)", {})
  vim.api.nvim_set_keymap("n", "<Leader>d0", "<Plug>lightline#bufferline#delete(10)", {})

  vim.g["lightline#bufferline#show_number"] = 2
  vim.g["lightline#bufferline#min_buffer_count"] = 2
end
