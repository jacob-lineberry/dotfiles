return {
  -- Markdown rendering in-buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
    opts = {
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },
}
