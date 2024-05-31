local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_path_cache = vim.fn.stdpath("cache") .. "/lazy/cache"
local lazy_path_plugins = vim.fn.stdpath("data") .. "/lazy"

if not vim.loop.fs_stat(lazy_path)
then
	print("plugins: Installing lazy.nvim ...")
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path
	})
	vim.notify("plugins: lazy.nvim successfully installed.")
end
vim.opt.rtp:prepend(lazy_path)

local lazy_opts = {
	root = lazy_path_plugins,
	change_detection = { enabled = false, notify = false },
	checker = { enabled = false },
	concurrency = 4,
	defaults = {
		lazy = false,
		version = "v10.*",
	},
	git = {
		timeout = 180,
	},
	install = { missing = true },
	performance = {
		cache = {
			enabled = true,
			path = lazy_path_cache,
		},
	},
}

local ok, lazy = pcall(require, "lazy")
if ok then lazy.setup("plugins", lazy_opts)
else
	vim.notify("plugins: Failed to require lazy.nvim")
end