return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		local treesitter_filetypes = {
			"c",
			"css",
			"csv",
			"dockerfile",
			"gitignore",
			"html",
			"ini",
			"java",
			"javascript",
			"javascriptreact",
			"json",
			"lua",
			"markdown",
			"php",
			"python",
			"query",
			"sh",
			"sql",
			"typescript",
			"typescriptreact",
			"vim",
			"xml",
			"yaml",
			"zsh",
		}

		treesitter.setup({})

		require("nvim-ts-autotag").setup({})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = treesitter_filetypes,
			callback = function(args)
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
