return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  tag = "v0.10.0",
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "python",
        "cpp",
        "c",
        "proto",
        "dockerfile",
        "starlark",
        "bash",
        "javascript",
        "lua",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = false },
    })
  end,
}
