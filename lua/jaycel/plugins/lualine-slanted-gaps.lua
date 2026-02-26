return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = function()
      local colors = {
        base     = "#1e1e2e", -- Base
        mantle   = "#181825", -- Mantle
        surface0 = "#313244", -- Surface 0
        surface1 = "#45475a", -- Surface 1

        text     = "#cdd6f4", -- Text
        subtext  = "#bac2de", -- Subtext 1

        red      = "#f38ba8", -- Red
        orange   = "#fab387", -- Peach
        yellow   = "#f9e2af", -- Yellow
        green    = "#a6e3a1", -- Green
        blue     = "#89b4fa", -- Blue
        mauve    = "#cba6f7", -- Mauve
      }

      local theme = {
        normal = {
          a = { fg = colors.base, bg = colors.blue, gui = "bold" },
          b = { fg = colors.text, bg = colors.surface0 },
          c = { fg = colors.text, bg = colors.base },
          z = { fg = colors.base, bg = colors.blue },
        },

        insert = {
          a = { fg = colors.base, bg = colors.green, gui = "bold" },
        },

        visual = {
          a = { fg = colors.base, bg = colors.mauve, gui = "bold" },
        },

        replace = {
          a = { fg = colors.base, bg = colors.red, gui = "bold" },
        },

        command = {
          a = { fg = colors.base, bg = colors.yellow, gui = "bold" },
        },

        inactive = {
          a = { fg = colors.subtext, bg = colors.surface0 },
          b = { fg = colors.subtext, bg = colors.base },
          c = { fg = colors.subtext, bg = colors.base },
        },
      }

      -- custom empty component
      local empty = require("lualine.component"):extend()

      function empty:draw(default_highlight)
        self.status = ""
        self.applied_separator = ""
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      -- section processor
      local function process_sections(sections)
        for name, section in pairs(sections) do
          local left = name:sub(9, 10) < "x"

          for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            table.insert(section, pos * 2, {
              empty,
              color = { fg = colors.text, bg = colors.base },
            })
          end

          for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
              comp = { comp }
              section[id] = comp
            end
            comp.separator = left and { right = "" } or { left = "" }
          end
        end

        return sections
      end

      -- search counter
      local function search_result()
        if vim.v.hlsearch == 0 then
          return ""
        end

        local last_search = vim.fn.getreg("/")
        if not last_search or last_search == "" then
          return ""
        end

        local searchcount = vim.fn.searchcount({ maxcount = 9999 })

        return last_search
            .. "("
            .. searchcount.current
            .. "/"
            .. searchcount.total
            .. ")"
      end

      -- modified indicator
      local function modified()
        if vim.bo.modified then
          return "+"
        elseif vim.bo.modifiable == false or vim.bo.readonly == true then
          return "-"
        end
        return ""
      end

      return {
        options = {
          theme = theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
        },

        sections = process_sections({
          lualine_a = { "mode" },

          lualine_b = {
            "branch",
            "diff",

            {
              "diagnostics",
              source = { "nvim" },
              sections = { "error" },
              diagnostics_color = {
                error = { bg = colors.red, fg = colors.base },
              },
            },

            {
              "diagnostics",
              source = { "nvim" },
              sections = { "warn" },
              diagnostics_color = {
                warn = { bg = colors.orange, fg = colors.base },
              },
            },

            { "filename", file_status = false,                                      path = 1 },

            -- { modified, color = { bg = colors.red } },

            { "%w",       cond = function() return vim.wo.previewwindow end },
            { "%r",       cond = function() return vim.bo.readonly end },
            { "%q",       cond = function() return vim.bo.buftype == "quickfix" end },
          },

          lualine_c = {},
          lualine_x = {},
          lualine_y = { search_result, "filetype" },
          lualine_z = { "%l:%c", "%p%%/%L" },
        }),

        inactive_sections = {
          lualine_c = { "%f %y %m" },
          lualine_x = {},
        },
      }
    end,
  },
}
