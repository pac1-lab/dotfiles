return {
  -- nvim-lspconfig is the main plugin for LSP configuration.
  -- This is where you configure the behavior of your LSPs.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- mason.nvim is a dependency of mason-lspconfig, so it must be set up first.
      {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        config = true, -- automatically calls setup()
      },
      -- mason-lspconfig.nvim is a bridge between mason and nvim-lspconfig.
      -- It must be set up after mason.nvim.
      {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
      },
      "hrsh7th/cmp-nvim-lsp", -- For autocompletion
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local keymap = vim.keymap

      -- The capabilities are required for all LSP servers
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Configure Mason-Lspconfig with your custom handlers and `ensure_installed`
      mason_lspconfig.setup({
        -- The list of servers you want installed and configured automatically
        ensure_installed = {
          "basedpyright",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "emmet_ls",
          "graphql",
          "html",
          "lua_ls",
          "prismals",
          "ruff",
          "svelte",
          "tailwindcss",
          "ts_ls",
          "yamlls",
        },
        handlers = {
          -- Default handler for all servers without a specific handler
          ["_"] = function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific handler for 'svelte'
          ["svelte"] = function()
            lspconfig.svelte.setup({
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                  pattern = { "*.js", "*.ts" },
                  callback = function(ctx)
                    client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                  end,
                })
              end,
            })
          end,

          -- Specific handler for 'graphql'
          ["graphql"] = function()
            lspconfig.graphql.setup({
              capabilities = capabilities,
              filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
            })
          end,

          -- Specific handler for 'emmet_ls'
          ["emmet_ls"] = function()
            lspconfig.emmet_ls.setup({
              capabilities = capabilities,
              filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
            })
          end,

          -- Specific handler for 'basedpyright'
          ["basedpyright"] = function()
            lspconfig.basedpyright.setup({
              capabilities = capabilities,
              settings = {
                basedpyright = {
                  typeCheckingMode = "standard",
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
                  completion = { callSnippet = "Replace" },
                },
              },
            })
          end,
        },
      })

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

      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
}
