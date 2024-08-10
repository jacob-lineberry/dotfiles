return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			local whichkey = require("which-key")

			-- set keybinds
			whichkey.add({
				{ "<leader>e", "<cmd>Neotree filesystem reveal left<CR>", desc = "Toggle the Neotree filesystem view" },
			})

			-- set neo-tree config
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true,
					},
				},
			})
		end,
	},
}
