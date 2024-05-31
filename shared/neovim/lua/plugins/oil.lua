-- File manager.
-- https://github.com/stevearc/oil.nvim

return {
	"stevearc/oil.nvim",
	version = "3.x",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function ()
		require("oil").setup({
			keymaps = {
				["<C-v>"] = "actions.select_vsplit",
				["<C-s>"] = "actions.select_split",
			}
		})
	end,
}