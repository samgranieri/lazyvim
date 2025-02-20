local Util = require("lazyvim.util")
local branch = { "branch", icon = "" }

local colors = {
	bg = "#202328",
	blue = "#51afef",
	cyan = "#008080",
	darkblue = "#081633",
	fg = "#bbc2cf",
	green = "#98be65",
	magenta = "#c678dd",
	orange = "#FF8800",
	purple = "#c678dd",
	red = "#ec5f67",
	violet = "#a9a1e1",
	yellow = "#ECBE7B",
}
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.o.columns > 100
	end,
}
local treesitter = {
	function()
		return ""
	end,
	color = function()
		local buf = vim.api.nvim_get_current_buf()
		local ts = vim.treesitter.highlighter.active[buf]
		return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
	end,
	cond = conditions.hide_in_width,
}
return {
	{
		"Bekaboo/dropbar.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>w",
				function()
					require("dropbar.api").pick()
				end,
				desc = "Winbar pick",
			},
		},
		opts = function()
			local menu_utils = require("dropbar.utils.menu")

			-- Closes all the windows in the current dropbar.
			local function close()
				local menu = menu_utils.get_current()
				while menu and menu.prev_menu do
					menu = menu.prev_menu
				end
				if menu then
					menu:close()
				end
			end

			return {
				icons = {
					ui = {
						-- Tweak the spacing around the separator.
						-- bar = { separator = "  " }, -- use this when in x,y,z position in lualine
						bar = { separator = "  " },
						menu = { separator = "" },
					},
					-- Keep the LSP icons used in other parts of the UI.
					kinds = {
						symbols = vim.tbl_map(function(symbol)
							return symbol .. " "
						end, LazyVim.config.icons.kinds),
					},
				},
				bar = {
					-- Remove the 'OptionSet' event since it causes weird issues with modelines.
					attach_events = { "BufWinEnter", "BufWritePost" },
					update_events = {
						-- Remove the 'WinEnter' event since I handle it manually for just
						-- showing the full dropbar in the current window.
						win = { "CursorMoved", "CursorMovedI", "WinResized" },
					},
					pick = {
						-- Use the same labels as flash.
						pivots = "asdfghjklqwertyuiopzxcvbnm",
					},
					sources = function()
						local sources = require("dropbar.sources")
						local utils = require("dropbar.utils.source")
						local filename = {
							get_symbols = function(buff, win, cursor)
								local symbols = sources.path.get_symbols(buff, win, cursor)
								return { symbols[#symbols] }
							end,
						}

						return {
							filename,
							{
								get_symbols = function(buf, win, cursor)
									if vim.api.nvim_get_current_win() ~= win then
										return {}
									end

									if vim.bo[buf].ft == "markdown" then
										return sources.markdown.get_symbols(buf, win, cursor)
									end
									return utils
										.fallback({ sources.lsp, sources.treesitter })
										.get_symbols(buf, win, cursor)
								end,
							},
						}
					end,
				},
				menu = {
					win_configs = { border = "rounded" },
					keymaps = {
						-- Navigate back to the parent menu.
						["h"] = "<C-w>c",
						-- Expands the entry if possible.
						["l"] = function()
							local menu = menu_utils.get_current()
							if not menu then
								return
							end
							local row = vim.api.nvim_win_get_cursor(menu.win)[1]
							local component = menu.entries[row]:first_clickable()
							if component then
								menu:click_on(component, nil, 1, "l")
							end
						end,
						-- "Jump and close".
						["o"] = function()
							local menu = menu_utils.get_current()
							if not menu then
								return
							end
							local cursor = vim.api.nvim_win_get_cursor(menu.win)
							local entry = menu.entries[cursor[1]]
							local component =
								entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
							if component then
								menu:click_on(component, nil, 1, "l")
							end
						end,
						-- Close the dropbar entirely with <esc> and q.
						["q"] = close,
						["<esc>"] = close,
					},
				},
			}
		end,
		config = function(_, opts)
			local bar_utils = require("dropbar.utils.bar")

			require("dropbar").setup(opts)

			-- Better way to do this? Follow up in https://github.com/Bekaboo/dropbar.nvim/issues/76
			vim.api.nvim_create_autocmd("WinEnter", {
				desc = "Refresh window dropbars",
				callback = function()
					-- Exclude the dropbar itself.
					if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].winbar == 1 then
						bar_utils.exec("update")
					end
				end,
			})
		end,

		dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "pnx/lualine-lsp-status" },
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			local icons = require("lazyvim.config").icons
			-- local dropbar = require("dropbar")
			-- vim.ui.select = require("dropbar.utils.menu").select

			vim.o.laststatus = vim.g.lualine_laststatus

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = {
						winbar = { "alpha", "neo-tree" },
						statusline = { "dashboard", "alpha", "starter" },
					},
				},
				inactive_winbar = {
					lualine_a = {},
					lualine_b = { "filename" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{
							"%{%v:lua.dropbar()%}",
							separator = { left = "", right = "" },
							color = "nil",
						},
					},
					lualine_x = { "filetype" },
					lualune_y = {},
					lualine_z = { treesitter },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { branch },
					lualine_c = {
						Util.lualine.root_dir(),
						"lsp-status",

						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ Util.lualine.pretty_path() },
					},
					lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function ()
                 return { fg = Snacks.util.color("Statement") }
              end
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function ()
                 return { fg = Snacks.util.color("Constant") }
              end
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function ()
                 return { fg = Snacks.util.color("Debug") }
              end
            },
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = function()
								return { fg = Snacks.util.color("Special") }
							end,
						},
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
				extensions = { "mason", "fzf", "neo-tree", "lazy" },
			}
		end,
	},
}
