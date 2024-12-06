-- return {}

-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore

return {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  opts = function ()
    require("solarized-osaka").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      transparent = true,
      -- transparent = true, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { bold = true },
        functions = {bold = true},
        variables = {   },
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      on_highlights = function(highlights, colors)
        highlights.TelescopeTitle = {
          fg= colors.blue,
        }
        highlights.TelescopeBorder = {
          fg=colors.blue,
        }
        highlights.CmpDocBorder= {
          fg = colors.blue
        }
        highlights.NoicePopupBorder = {
          fg = colors.blue
        }
        highlights.CmpBorder = {
          fg = colors.blue
        }
        highlights.LineNr = {
          fg = colors.base01
        }
        -- highlights.Pmenu = {
        --   fg = colors.yellow100,
        --   bg = colors.green700
        -- }
      end
    })
    vim.cmd[[colorscheme solarized-osaka]]
  end

}
