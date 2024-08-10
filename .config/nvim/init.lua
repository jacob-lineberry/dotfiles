-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable line numbers
vim.opt.number = true

-- sync clipboard between os and nvim
vim.opt.clipboard = "unnamedplus"

-- tabs vs spaces
vim.o.tabstop = 2 -- a tab character looks like 4 spaces
vim.o.expandtab = true -- pressing the tab key will insert spaces instead of a tab character
vim.o.softtabstop = 2 -- number of spaces inserted instead of a tab character
vim.o.shiftwidth = 2 -- number of spaces inserted when indenting

-- load lazy
require("config.lazy")
