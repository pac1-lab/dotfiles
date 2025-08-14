-- lua/flaco/plugins/dadbod.lua
local sql_ft = { "sql", "mysql", "plsql" }

return {
	-- Core
	{
		"tpope/vim-dadbod",
		cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	},

	-- UI
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
		},
		init = function()
			local data_path = vim.fn.stdpath("data")
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
			vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
			vim.g.db_ui_use_nerd_fonts = true
			vim.g.db_ui_use_nvim_notify = true
			vim.g.db_ui_execute_on_save = false
			-- Optional: named connections for DBUI (edit to taste)
			-- vim.g.dbs = {
			--   construction = "sqlite:" .. vim.fn.getcwd() .. "/instance/construction.db",
			-- }
		end,
	},

	-- Completion (nvim-cmp source)
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod" },
		ft = sql_ft,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = sql_ft,
				callback = function()
					local ok, cmp = pcall(require, "cmp")
					if not ok then
						return
					end
					-- Prepend DB completion to existing sources for this buffer
					cmp.setup.buffer({
						sources = cmp.config.sources({ { name = "vim-dadbod-completion" } }, cmp.get_config().sources),
					})
				end,
			})
		end,
	},
}
