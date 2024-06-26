-- [[ Setting options ]]
-- See `:help vim.o`
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Make relative line numbers default
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

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

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.php", "*.inc" },
	callback = function()
		vim.bo.filetype = "php"
	end,
})

--For vim-closetag
vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.tsx,*.js,*.ts,*.jsx"
vim.g.closetag_xhtml_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.tsx,*.js,*.ts,*.jsx"
vim.g.closetag_filetypes = "html,xhtml,phtml,php,javascript,typescriptreact,javascriptreact,ph"
vim.g.closetag_xhtml_filetypes = "html,xhtml,phtml,php,javascript,typescriptreact,javascriptreact,ph"
vim.g.closetag_emptyTags_caseSensitive = 1
vim.g.closetag_shortcut = '>'
vim.g.closetag_close_shortcut = '/'
vim.g.closetag_regions = {
	['typescript.tsx'] = 'jsxRegion,tsxRegion',
	['javascript.jsx'] = 'jsxRegion',
	['php'] = 'phpRegion',
}
