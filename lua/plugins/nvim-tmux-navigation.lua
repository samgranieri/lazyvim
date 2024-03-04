return {
  "alexghergh/nvim-tmux-navigation",
  opts = function()
    local plugin = require("nvim-tmux-navigation")
    local options = {
      disable_when_zoomed = true, -- defaults to false
    }

    plugin.setup(options)
  end,
  keys = {
    { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "Got to the left pane" },
    { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "Got to the down pane" },
    { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "Got to the up pane" },
    { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "Got to the right pane" },
  },
}
