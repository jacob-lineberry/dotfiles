return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- instantiate the lsp config
			local lspconfig = require("lspconfig")
			-- lua
			lspconfig.lua_ls.setup({})
			-- python
			lspconfig.pyright.setup({
				filetytpes = { "python" },
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
			-- define keybinds
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		end,
	},
}
