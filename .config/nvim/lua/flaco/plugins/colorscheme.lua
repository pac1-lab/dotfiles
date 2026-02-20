return {
	{
		"tiesen243/vercel.nvim",
		priority = 1000,
		config = function()
			require("vercel").setup({
				theme = "dark", -- String: Sets the theme to light or dark (Default: light)
				transparent = false, -- Boolean: Sets the background to transparent (Default: false)
				italics = {
					comments = true, -- Boolean: Italicizes comments (Default: true)
					keywords = true, -- Boolean: Italicizes keywords (Default: true)
					functions = true, -- Boolean: Italicizes functions (Default: true)
					strings = true, -- Boolean: Italicizes strings (Default: true)
					variables = true, -- Boolean: Italicizes variables (Default: true)
					bufferline = false, -- Boolean: Italicizes bufferline (Default: false)
				},
				overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
			})

			-- This must be called before setting the colorscheme, otherwise it will always default to light mode
			vim.cmd.colorscheme("vercel")
		end,
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		local bg = "#011628"
	-- 		local bg_dark = "#011423"
	-- 		local bg_highlight = "#143652"
	-- 		local bg_search = "#0A64AC"
	-- 		local bg_visual = "#275378"
	-- 		local fg = "#CBE0F0"
	-- 		local fg_dark = "#B4D0E9"
	-- 		local fg_gutter = "#627E97"
	-- 		local border = "#547998"
	--
	-- 		require("tokyonight").setup({
	-- 			style = "night",
	-- 			on_colors = function(colors)
	-- 				colors.bg = bg
	-- 				colors.bg_dark = bg_dark
	-- 				colors.bg_float = bg_dark
	-- 				colors.bg_highlight = bg_highlight
	-- 				colors.bg_popup = bg_dark
	-- 				colors.bg_search = bg_search
	-- 				colors.bg_sidebar = bg_dark
	-- 				colors.bg_statusline = bg_dark
	-- 				colors.bg_visual = bg_visual
	-- 				colors.border = border
	-- 				colors.fg = fg
	-- 				colors.fg_dark = fg_dark
	-- 				colors.fg_float = fg
	-- 				colors.fg_gutter = fg_gutter
	-- 				colors.fg_sidebar = fg_dark
	-- 			end,
	-- 		})
	-- 		-- load the colorscheme here
	-- 		vim.cmd([[colorscheme tokyonight]])
	-- 	end,
	--  },

	-- {

	--    "catppuccin/nvim",
	--		name = "catppuccin",
	--		priority = 1000, -- make sure to load this before all the other start plugins
	--		config = function()
	--			require("catppuccin").setup({
	--				flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
	--				transparent_background = false,
	--				term_colors = true,
	--				integrations = {
	--					cmp = true,
	--					gitsigns = true,
	--					nvimtree = true,
	--					telescope = true,
	--					treesitter = true,
	--					mason = true,
	--					-- more integrations if needed
	--				},
	--				custom_highlights = function(colors)
	--					return {
	--						Normal = { bg = colors.base },
	--						Visual = { bg = colors.surface1 },
	--						Search = { bg = colors.yellow, fg = colors.base },
	--					}
	--				end,
	--			})
	--			-- load the colorscheme here
	--			vim.cmd([[colorscheme catppuccin]])
	--		end,
	-- },
}
