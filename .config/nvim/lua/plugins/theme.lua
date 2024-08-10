return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- load theme during startup
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
}
