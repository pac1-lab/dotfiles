return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")
    local context_commentstring = require("ts_context_commentstring")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    context_commentstring.setup({
      enable_autocmd = false,
    })

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
