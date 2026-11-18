return {
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
}
