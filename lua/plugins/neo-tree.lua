-- return {}

return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		window = {
			mappings = {
				["<space>"] = "none",
				["Y"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.setreg("+", path, "c")
				end,
			},
		},
		source_selector = {
			winbar = true,
			statusline = true,
			show_scrolled_off_parent_node = false,
			sources = {
				{ source = "filesystem" },
				{ source = "buffers" },
				{ source = "git_status" },
			},
		},
	},
}
