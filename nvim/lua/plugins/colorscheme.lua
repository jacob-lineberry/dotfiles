return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      on_highlights = function(hl, c)
        hl.Directory = { fg = c.magenta }
        hl.NeoTreeDirectoryIcon = { fg = c.magenta }
        hl.NeoTreeDirectoryName = { fg = c.magenta }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
