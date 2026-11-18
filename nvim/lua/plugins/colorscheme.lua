return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      highlight_overrides = {
        mocha = function(mocha)
          return {
            Directory = { fg = mocha.pink },
            NeoTreeDirectoryIcon = { fg = mocha.pink },
            NeoTreeDirectoryName = { fg = mocha.pink },
          }
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
