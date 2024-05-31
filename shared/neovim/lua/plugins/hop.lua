-- Jump anywhere.
-- https://github.com/phaazon/hop.nvim

-- NOTE: Temporarily using mistweaverco/hop.nvim because #340 hasn't landed
-- yet. https://github.com/phaazon/hop.nvim/pull/340

return {
	"mistweaverco/hop.nvim",
	config = function ()
		require("hop").setup({
			case_insensitive = true,
			jump_on_sole_occurrence = true,
			multi_windows = true,
		})
	end,
}