-- Highligh changes in files under Git's version control.
-- https://github.com/lewis6991/gitsigns.nvim

return {
	"lewis6991/gitsigns.nvim",
	config = function ()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			attach_to_untracked = false,
			signs = {
				add = {
					hl = "GitSignsAdd",
					text = "▎",
					numhl = "GitSignsAddNr",
					linehl = "GitSignsAddLn"
				},
				change = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn"
				},
				delete = {
					hl = "GitSignsDelete",
					text = "▎",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn"
				},
				topdelete = {
					hl = "GitSignsDelete",
					text = "▎",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn"
				},
				changedelete = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn"
				},
			},
		})
	end
}