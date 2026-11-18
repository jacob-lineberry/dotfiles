return {
  -- ruff and ty come from Homebrew (see the Brewfile), not Mason
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = { mason = false },
        ty = { mason = false },
      },
    },
  },
}
