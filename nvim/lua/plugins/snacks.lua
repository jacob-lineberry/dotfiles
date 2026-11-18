return {
  -- Customizing snacks.nvim terminal and toggles
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { timeout = 3000 },
      explorer = { enabled = true },
      picker = {
        sources = {
          explorer = { hidden = true, ignored = true },
        },
      },
      indent = {
        enabled = true,
        char = "│",
        scope = { enabled = false },
      },
      dashboard = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      terminal = {
        win = {
          wo = { winbar = "" },
          border = "rounded",
          padding = { top = 1, bottom = 1, left = 2, right = 2 },
        },
      },
    },
    keys = {
      -- Show/Dismiss notifications
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      -- Main Toggle Terminal
      {
        "<C-\\>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
    },
    config = function(_, opts)
      -- Let Snacks apply the custom options
      require("snacks").setup(opts)

      -- Generate 1 to 9 bindings for bottom, vertical, and floating multi-terminal slots
      for i = 1, 9 do
        vim.keymap.set({ "n", "t" }, string.format("<leader>t%d", i), function()
          Snacks.terminal(nil, { win = { position = "bottom" }, count = i })
        end, { desc = string.format("Toggle Terminal %d", i) })

        vim.keymap.set({ "n", "t" }, string.format("<leader>v%d", i), function()
          Snacks.terminal(nil, { win = { position = "right" }, count = i })
        end, { desc = string.format("Toggle Vertical Terminal %d", i) })

        vim.keymap.set({ "n", "t" }, string.format("<leader>f%d", i), function()
          Snacks.terminal(vim.o.shell, { win = { position = "float", backdrop = 60 }, count = i })
        end, { desc = string.format("Toggle Floating Terminal %d", i) })
      end
    end,
  },

  -- Slanted bufferline tabs with precise offsets for snacks panels
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        offsets = {
          {
            filetype = "snacks_explorer",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_terminal",
            text = "Terminal",
            highlight = "Special",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Markdown rendering in-buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
    opts = {
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },
}
