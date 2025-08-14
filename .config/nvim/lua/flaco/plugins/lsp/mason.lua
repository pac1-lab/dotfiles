return {
	"williamboman/mason.nvim",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- For autocompletion
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

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
				"basedpyright", -- Language server for Python
				"ruff",

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
			handlers = {
				-- Default handler for all servers without a specific handler
				function(server)
					lspconfig[server].setup({
						capabilities = capabilities,
					})
				end,

				["ts_ls"] = function()
					require("lspconfig").ts_ls.setup({
						capabilities = capabilities,
						on_attach = function(client)
							client.server_capabilities.documentFormattingProvider = false
						end,
						settings = {
							typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
							javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
						},
					})
				end,

				-- Specific handler for 'emmet_ls'
				["emmet_ls"] = function()
					lspconfig.emmet_ls.setup({
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
				end,

				-- Specific handler for 'basedpyright'
				["basedpyright"] = function()
					require("lspconfig").basedpyright.setup({
						capabilities = capabilities,
						settings = {
							basedpyright = {
								typeCheckingMode = "standard", -- or "basic"/"off" if you prefer
							},
						},
					})
				end,

				["ruff_lsp"] = function()
					require("lspconfig").ruff_lsp.setup({
						capabilities = capabilities,
						init_options = { settings = { args = {} } }, -- room for per-project .ruff.toml overrides
					})
				end,

				["jsonls"] = function()
					require("lspconfig").jsonls.setup({
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,

				["yamlls"] = function()
					require("lspconfig").yamlls.setup({
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = { enable = false, url = "" }, -- we use schemastore.nvim instead
								schemas = require("schemastore").yaml.schemas(),
								keyOrdering = false,
							},
						},
					})
				end,

				-- Specific handler for 'lua_ls'
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end,

				["sqlls"] = function()
					local lspconfig = require("lspconfig")
					local util = require("lspconfig.util")
					lspconfig.sqlls.setup({
						capabilities = capabilities,
						root_dir = util.root_pattern(".sqllsrc.json", ".git") or util.path.dirname, -- fallback to cwd
					})
				end,
			},
		})

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
