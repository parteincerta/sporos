-- Colorscheme
-- https://folke/tokyonight.nvim

return {
	"folke/tokyonight.nvim",
	enabled = true,
	version = "2.x",
	config = function ()
		local tokyo = require("tokyonight")
		tokyo.setup({
			style = 'moon',
			transparent = true,
			on_highlights = function (hl, c)
				hl.BufferLineBackground = { fg = c.comment, bg = c.bg }
				hl.BufferLineBuffer = { fg = c.comment, bg = c.bg }
				hl.BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true }
				hl.BufferLineBufferVisible = { fg = c.fg, bg = c.bg }
				hl.BufferLineCloseButton = { fg = c.comment, bg = c.bg }
				hl.BufferLineCloseButtonSelected = { fg = c.fg, bg = c.bg, bold = true }
				hl.BufferLineCloseButtonVisible = { fg = c.fg, bg = c.bg }
				hl.BufferLineTab = { fg = c.comment, bg = c.bg }
				hl.BufferLineTabSelected = { fg = c.fg, bg = c.bg, bold = true }
				hl.BufferLineTabSeparator = { fg = c.bg, bg = c.bg }
				hl.BufferLineTabSeparatorSelected = { fg = c.bg, bg = c.bg }

				hl.ColorColumn = { bg = c.bg_highlight }

				hl.NeoTreeFloatBorder = { bg = c.bg }
				hl.NeoTreeFloatTitle = { bg = c.bg }
				hl.NeoTreeNormal = { bg = c.bg }
				hl.NeoTreeNormalNC = { bg = c.bg }

				hl.WinSeparator = { fg = c.dark3 }

				hl['@text.diff.add'] = { link = "diffAdded" }
				hl['@text.diff.delete'] = { link = "diffRemoved" }
				hl['DiagnosticUnnecessary'] = { link = "@comment" }
			end,
			styles = {
				comments = { italic = false },
			},
		})

		vim.cmd[[colorscheme tokyonight-moon]]
	end,
}