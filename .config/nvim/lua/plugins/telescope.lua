return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		cmd = "Telescope",
		config = function()
			local builtin = require("telescope.builtin")
			local whichkey = require("which-key")

			-- define keybinds using the correct format
			whichkey.add({
				{ "<leader>f", group = "file" }, -- group
				{ "<leader>fb", builtin.buffers, desc = "Find Buffer" },
				{ "<leader>ff", builtin.find_files, desc = "Find Files" },
				{ "<leader>fg", builtin.live_grep, desc = "Find with Grep" },
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
