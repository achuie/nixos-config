--[[ Leader ]]

-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '


--[[ Lazy ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


--[[ Plugins ]]

-- NOTE: `opts = {}` is the same as calling `require('<plugin>').setup({})`
require('lazy').setup({
  -- Git-related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- File browser
  'justinmk/vim-dirvish',

  -- Tell Vim about common word separators
  'chaoren/vim-wordmotion',

  -- Navigate by indentation level
  'jeetsukumaran/vim-indentwise',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Updated surround
  { 'kylechui/nvim-surround', opts = {} },

  -- LSP plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- A number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Show pending keybinds
  { 'folke/which-key.nvim', opts = {} },

  -- Git related gutter signs & utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = "moon",
      on_highlights = function(hl, c)
        -- Show gutter tildes beyond end of file
        hl.EndOfBuffer = { fg = c.bg_highlight }
      end,
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
        dev = true,
      },
    },
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    dev = true,
  },
}, {
  -- NixOS-managed plugin path
  dev = {
    path = "~/.local/share/nvim/nix",
    fallback = false,
  },
  performance = {
    -- Don't reset packpath so as to still find NixOS-managed plugins.
    reset_packpath = false,
  },
})


--[[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = true

-- Confirm dialog
vim.o.confirm = true

-- Make relative line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode but not in Visual
vim.o.mouse = 'nih'

-- Enable break indent
-- vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- Use 4 spaces instead of tabs
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Make tabs 8 spaces long
vim.o.tabstop = 8

-- Set line length to 100
vim.o.textwidth = 120

--[[
  c  Auto-wrap comments using textwidth, inserting the current comment leader
        automatically.
  q  Allow formatting of comments with "gq".
  r  Automatically insert the current comment leader after hitting <Enter> in
        Insert mode. 
  t  Auto-wrap text using textwidth (does not apply to comments)
]]
vim.o.formatoptions = 'c,q,r,t'

-- Show tabs and indicate long lines
vim.o.list = true
vim.opt.listchars = { tab = '›—', extends = '→', precedes = '←', nbsp = '·' }

-- Window splits
vim.o.splitbelow = true
vim.o.splitright = true


--[[ Keymaps ]]

-- Remove default space mapping
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Use <F11> to toggle Paste Insert mode and numbers
vim.keymap.set('n', '<F11>', function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.go.paste = not vim.go.paste
end)

-- Map redraw screen command to also turn off search highlighting until the next search
vim.keymap.set('n', '<C-L>', ':nohl<CR><C-L>')

-- Buffer mappings
vim.keymap.set('n', '[b', ':bprev<CR>')
vim.keymap.set('n', ']b', ':bnext<CR>')

-- Tab mappings
vim.keymap.set('n', 'th', ':tabfirst<CR>')
vim.keymap.set('n', '[t', ':tabprev<CR>')
vim.keymap.set('n', ']t', ':tabnext<CR>')
vim.keymap.set('n', 'tl', ':tablast<CR>')
vim.keymap.set('n', 'tt', ':tabedit<Space>')
vim.keymap.set('n', 'tn', ':tabnew<CR>')
vim.keymap.set('n', 'tm', ':tabm<Space>')
vim.keymap.set('n', 'td', ':tabclose<CR>')

-- Search for visually selected text
vim.keymap.set('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- Fold lines not matching previous search; `zr` for more context, `zm` for less
vim.keymap.set('n', '<Leader>z', function()
    vim.cmd([[:setlocal
    \ foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
    \ foldmethod=expr foldlevel=0 foldcolumn=2]])
end)

-- Toggle error highlighting for overlength lines
vim.keymap.set('n', '<Leader>l', function()
    vim.cmd(vim.api.nvim_replace_termcodes([[
    if exists('w:long_line_match') <Bar>
    \   silent! call matchdelete(w:long_line_match) <Bar>
    \   unlet w:long_line_match <Bar>
    \ elseif &textwidth > 0 <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>'.&tw.'v.\+',-1) <Bar>
    \ else <Bar>
    \   let w:long_line_match = matchadd('ErrorMsg','\%>80v.\+',-1) <Bar>
    \ endif]], true, true, true))
end, { silent = true })

-- Fill line with char
vim.cmd([[function! FillLine(str)
    let reps = (&textwidth - col("$") + 1) / len(a:str)
    if reps > 0
        .s/$/\=(''.repeat(a:str, reps))/
    endif
endfunction]])

-- Recognize Pollen files as racket code
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'BufWritePost' }, {
  pattern = { '*.p', '*.pp', '*.pm' },
  command = 'set filetype=racket',
})


--[[ Colorscheme ]]

vim.cmd.colorscheme 'tokyonight'


--[[ Configure Telescope ]]

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<M-p>'] = require('telescope.actions.layout').toggle_preview,
      },
      n = {
        ['<M-p>'] = require('telescope.actions.layout').toggle_preview,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
local status, err = pcall(require('telescope').load_extension, 'fzf')
if not status then
  print(string.format('Could not load native fzf for telescope: %s', err))
end

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 5,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end
vim.keymap.set('v', '<leader>sg', function()
  local text = vim.getVisualSelection()
  require('telescope.builtin').live_grep({ default_text = text })
end, { desc = '[S]earch by [G]rep for current selection' })
vim.keymap.set('v', '<leader>/', function()
  local text = vim.getVisualSelection()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    default_text = text,
    winblend = 5,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search for current selection in current buffer' })

vim.keymap.set('n', '<leader>t', function()
require('telescope.builtin').treesitter(require('telescope.themes').get_dropdown {
    winblend = 5,
    previewer = false,
  })
end, { desc = 'Search [T]ags' })


--[[ Configure Treesitter ]]

-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  -- Use a line count threshold to flag a buffer as long
  local longBuffer = function(_, bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 30000
  end

  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup {
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
      disable = longBuffer,
    },
    indent = {
      enable = true,
      disable = longBuffer,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = '<c-space>',
        -- node_incremental = '<c-space>',
        -- scope_incremental = '<c-s>',
        -- node_decremental = '<M-space>',
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
      disable = longBuffer,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      disable = longBuffer,
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


--[[ Configure LSP ]]

-- This function gets run when an LSP connects to a particular buffer
local on_attach = function(_, bufnr)
  -- Helper for LSP related keymaps: set the mode, buffer, and description
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
require('which-key').register({ ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' }}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

--[[
  Enable the following language servers
    Any additional override configuration in the following tables will be passed to the `settings` field of the server
    config

    Define the property 'filetypes' to override the default filetypes for a language server

  Print actual config for debugging:
    `:lua print(vim.inspect(vim.lsp.get_active_clients()))`
]]
local servers = {
  -- clangd = {},
  -- gopls = {},
  ruff_lsp = {},
  nil_ls = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = "Disable" },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}


--[[ Configure nvim-cmp ]]

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

---@diagnostic disable-next-line: missing-fields
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
