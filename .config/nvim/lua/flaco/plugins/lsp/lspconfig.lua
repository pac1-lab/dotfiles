return {
	-- nvim-lspconfig is the main plugin for LSP configuration.
	-- This is where you configure the behavior of your LSPs.
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- For autocompletion
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- import lspconfig plugin
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local keymap = vim.keymap

			-- The capabilities are required for all LSP servers
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- The rest of your configuration (autocmds, keymaps, etc.)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					opts.desc = "Show LSP references"
					keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Show LSP definitions"
					keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show LSP implementations"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Go to previous diagnostic"
					keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					opts.desc = "Go to next diagnostic"
					keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				end,
			})

			local icons = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 }, -- subtle dot, not noisy
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN]  = icons.Warn,
            [vim.diagnostic.severity.HINT]  = icons.Hint,
            [vim.diagnostic.severity.INFO]  = icons.Info,
          },
          numhl = false,  -- set true if you prefer numberline highlight instead of glyphs
        },
        underline = true,
        upated_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })
      -- rounded borders for hover + signature help
      local h = vim.lsp.handlers
      vim.lsp.handlers["textDocument/hover"]         = vim.lsp.with(h.hover,         { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(h.signature_help, { border = "rounded" })

      -- optional: show diagnostics for the cursor line automatically
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = "rounded" })
        end,
      })
		end,
	},
}
