-- Ensure that this section is before you require plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.codeium_enabled = false
vim.g.copilot_enabled = false

-- Install `lazy.nvim` plugin manager
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

--Initialize Lazy and Plugins
require('lazy').setup({
  -- DAP Related --
  'mfussenegger/nvim-dap',
  { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' } },
  { "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'jay-babu/mason-nvim-dap.nvim',

  -- Plugin Folder --
  { import = 'jaycel.plugins' },
  --Plugins that don't require any configuration
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  --Vim surround
  'tpope/vim-surround',

  -- UndoTree
  'mbbill/undotree',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',   opts = {} },

  { "folke/neodev.nvim",      opts = {} },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',     opts = {} },
  --Idk why I need this
  'nvim-neotest/nvim-nio',
  -- LSP Related --
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lua',
  'L3MON4D3/LuaSnip',
  'rafamadriz/friendly-snippets',
  'neovim/nvim-lspconfig',
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  'MunifTanjim/prettier.nvim',
}, {})


-- [[ Mason nvim dap]]
require("mason").setup()
require('mason-nvim-dap').setup {
  automatic_setup = true,
  handlers = {
    function(config)
      require('mason-nvim-dap').default_setup(config)
    end,
  },
}

-- PHP Debug Adapter Protocol (DAP) Configuration
local dap = require('dap')
local dapui = require('dapui')

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/home/jaycel/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    hostname = '0.0.0.0',
  }
}

function InsertXDebug()
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(1, pos) .. "xdebug_break();" .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
end

-- Toggle Xdebug
vim.keymap.set("n", "<leader>ds", "<cmd>lua InsertXDebug()<CR>")

dapui.setup {
  -- Customize icons
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      disconnect = "",
      pause = "",
      play = "",
      run_last = "",
      step_back = "",
      step_into = "",
      step_out = "",
      step_over = "",
      terminate = ""
    },
  }
}

-- Toggle UI elements when triggering events
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Basic debugging keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: Toggle UI' })

-- Source Settings
require 'jaycel.options.settings'
-- Source Remaps
require 'jaycel.options.remaps'

-- mason-lspconfig requires that these setup functions are called in this order
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  clangd = {},
  gopls = {},
  rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
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
  ensure_installed = {
    'clangd',
    'html',
    'lua_ls',
    'phpactor',
    'intelephense',
    'pyright',
    'rust_analyzer',
    'tsserver',
  },
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

-- Setup LSP
local lspconfig = require('lspconfig')

-- Setup LSP for EMMET
lspconfig.emmet_language_server.setup {
  on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  filetypes = { 'html', 'css', 'javascript', 'typescript', 'eruby', 'php' }, -- Add php here
  init_options = {
    html = {
      options = {
        -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        ["bem.enabled"] = true,
      }
    }
  }
}
-- Root directory detection function
local function get_php_root_dir(fname)
  return require('lspconfig.util').root_pattern('composer.json', '.git')(fname) or vim.fn.getcwd()
end
-- Setup LSP for intelephense
lspconfig.intelephense.setup {
  on_attach = function(client, bufnr)
    print("Intelephense LSP attached to buffer " .. bufnr)
    -- Additional configuration if needed
  end,
  flags = {
    debounce_text_changes = 150,
  },
  root_dir = get_php_root_dir,
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000, -- Adjust max file size if needed
      },
    },
  },
}

-- Setup LSP for phpactor
lspconfig.phpactor.setup {
  on_attach = function(client, bufnr)
    print("Phpactor LSP attached to buffer " .. bufnr)
    -- Additional configuration if needed
  end,
  flags = {
    debounce_text_changes = 150,
  },
  root_dir = get_php_root_dir,
}



-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(), -- Hide the completion menu in insert mode
      c = cmp.mapping.close(), -- Hide the completion menu in command mode
    }),
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
    { name = 'codeium' },
    { name = 'path' },
  },
}

-- [[ Configure Prettier ]]
local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "php",
    "yaml",
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
