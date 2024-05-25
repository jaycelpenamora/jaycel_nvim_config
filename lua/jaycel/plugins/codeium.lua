return {
  "Exafunction/codeium.nvim",
  event = 'BufEnter',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    vim.g.codeium_disable_bindings = 1

    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<M-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end)
    vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end)
    vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    -- BLOCK Codeium from accepting changes when tab is pressed.
    vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Ignore']() end, { expr = true, silent = true })
  end
}
--
