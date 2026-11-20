return {
  -- ruff and ty come from mise (see mise/config.toml), not Mason
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
