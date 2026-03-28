return {
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
	{ "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
	{ "navarasu/onedark.nvim", lazy = false, priority = 1000 },
	{ "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
	{ "sainnhe/gruvbox-material", lazy = false, priority = 1000 },
	{ "sainnhe/everforest", lazy = false, priority = 1000 },
	{ "bluz71/vim-moonfly-colors", lazy = false, priority = 1000 },
	{ "thesimonho/kanagawa-paper.nvim", lazy = false, priority = 1000 },

	-- Themery
	{
		"zaldih/themery.nvim",
		lazy = false,
		priority = 900,
		config = function()
			local function apply_custom_highlights()
				vim.opt.termguicolors = true
				vim.api.nvim_set_hl(0, "Visual", { bg = "#FFD700", fg = "#000000" })

				-- Force transparent background for all colorschemes
				local transparent_groups = {
					"Normal",
					"NormalFloat",
					"NormalNC",
					"SignColumn",
					"LineNr",
					"Folded",
					"EndOfBuffer",
					"FloatBorder",
				}

				for _, group in ipairs(transparent_groups) do
					vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
				end
			end
			vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_custom_highlights })

			-- Apply immediately for current session
			apply_custom_highlights()

			require("themery").setup({
				themes = {
					-- rose-pine
					{ name = "Rose Pine", colorscheme = "rose-pine" },
					{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
					{ name = "Rose Pine Dawn", colorscheme = "rose-pine-dawn" },

					-- tokyonight
					{ name = "Tokyonight", colorscheme = "tokyonight" },

					-- catppuccin
					{ name = "Catppuccin", colorscheme = "catppuccin" },

					-- gruvbox.nvim
					{ name = "Gruvbox (ellisonleao)", colorscheme = "gruvbox" },

					-- onedark
					{ name = "OneDark", colorscheme = "onedark" },

					-- nightfox family
					{ name = "Nightfox", colorscheme = "nightfox" },
					{ name = "Dawnfox", colorscheme = "dawnfox" },
					{ name = "Dayfox", colorscheme = "dayfox" },
					{ name = "Duskfox", colorscheme = "duskfox" },
					{ name = "Nordfox", colorscheme = "nordfox" },
					{ name = "Terafox", colorscheme = "terafox" },
					{ name = "Carbonfox", colorscheme = "carbonfox" },

					-- kanagawa.nvim family
					{ name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
					{ name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
					{ name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },

					-- NEW: gruvbox-material
					{ name = "Gruvbox Material", colorscheme = "gruvbox-material" },

					-- NEW: everforest
					{ name = "Everforest", colorscheme = "everforest" },

					-- NEW: moonfly
					{ name = "Moonfly", colorscheme = "moonfly" },

					-- NEW: kanagawa-paper
					-- (this one's colorscheme name is typically "kanagawa-paper")
					{ name = "Kanagawa Paper", colorscheme = "kanagawa-paper" },
				},

				livePreview = true,
			})

			-- Create custom command for easier access
			vim.api.nvim_create_user_command("Colorscheme", "Themery", {})
		end,
	},
}
