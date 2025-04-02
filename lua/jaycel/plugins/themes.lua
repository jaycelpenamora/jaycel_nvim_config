return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparency = false,
        color_overrides = {
          macchiato = {
            base = "#191B20",
            mantle = "#191B20",
            crust = "#191B20",
          }
        },
        integrations = {
          treesitter = true,
          telescope = true,
          gitgutter = true,
          gitsigns = true,
          indent_blankline = true,
          nvimtree = true,
          bufferline = true,
          hop = true,
          -- vim_illuminate = true,
          -- vim_signify = true,
          -- vim_startify = true,
          -- vim_gitgutter = true,
        },
      })
      vim.cmd([[colorscheme catppuccin-macchiato]])
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
