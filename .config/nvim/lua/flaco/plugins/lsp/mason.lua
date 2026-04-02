return {
	"williamboman/mason.nvim",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- For autocompletion
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		local util = require("lspconfig.util")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local enabled_servers = {
			"pylsp",
			"html",
			"cssls",
			"ts_ls",
			"emmet_ls",
			"dockerls",
			"docker_compose_language_service",
			"yamlls",
			"jsonls",
			"lua_ls",
			"sqlls",
		}

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				-- Python
				"pylsp", -- Language server for Python

				-- Web Development (HTML/CSS/JS)
				"html", -- HTML language server
				"cssls", -- CSS language server
				"ts_ls", -- TypeScript language server (also handles JavaScript)
				"emmet_ls", -- Snippet engine for HTML/CSS

				-- Infra
				"dockerls", -- Dockerfile language server
				"docker_compose_language_service", -- Docker Compose language server
				"yamlls", -- YAML language server (for docker-compose)
				"jsonls", -- JSON language server (for config files, etc.)

				-- Neovim Configuration
				"lua_ls", -- Lua language server (essential for your config)

				-- SQL
				"sqlls", -- SQL language server
			},
			automatic_enable = false,
		})

		vim.lsp.config("pylsp", {
			capabilities = capabilities,
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = { enabled = false },
						mccabe = { enabled = false },
						pyflakes = { enabled = true },
						rope_completion = { enabled = true },
					},
				},
			},
		})

		vim.lsp.config("html", {
			capabilities = capabilities,
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})

		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
			end,
			settings = {
				typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
				javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
			},
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
			},
		})

		vim.lsp.config("dockerls", {
			capabilities = capabilities,
		})

		vim.lsp.config("docker_compose_language_service", {
			capabilities = capabilities,
		})

		vim.lsp.config("jsonls", {
			capabilities = capabilities,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("yamlls", {
			capabilities = capabilities,
			settings = {
				yaml = {
					schemaStore = { enable = false, url = "" },
					schemas = require("schemastore").yaml.schemas(),
					keyOrdering = false,
				},
			},
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		vim.lsp.config("sqlls", {
			capabilities = capabilities,
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				on_dir(util.root_pattern(".sqllsrc.json", ".git")(fname) or vim.fs.dirname(fname))
			end,
		})

		for _, server in ipairs(enabled_servers) do
			vim.lsp.enable(server)
		end

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				"eslint_d",
				"djlint",
				"sqlfluff", -- SQL formatter and linter for stricter engforcement
			},
		})
	end,
}
