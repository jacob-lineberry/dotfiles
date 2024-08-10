return {
	auto_install = true, -- automatically install syntax support
	ensure_installed = {
		"dockerfile",
		"gitignore",
		"go",
		"groovy",
		"python",
		"terraform",
		"toml",
		"yaml",
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
	autotag = {
		enable = true,
		enable_rename = true,
		enable_close = true,
		enable_close_on_slash = true,
		filetypes = { "html", "xml" },
	},
}
