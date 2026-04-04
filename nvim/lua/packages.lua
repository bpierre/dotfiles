-- Ensure packpath includes the user data directory
vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "/site")

-- specs.name is used both for the dir name and
-- as the module name used for the require call.
local function pack_add(conf, load)
  if type(conf) ~= "table" then
    error("plugin configuration missing or invalid.")
  end

  if not conf.name then
    error("name missing in plugin configuration.")
  end
  if not conf.src then
    error("source missing in plugin configuration.")
  end

  vim.pack.add({ {
    name = conf.name,
    src = conf.src,
    version = conf.version,
  } }, {
    load = load == nil and true or load,
  })

  local main_module = nil
  local function require_plugin(name)
    if name then
      return require(name)
    end
    if not main_module then
      main_module = require(conf.name)
    end
    return main_module
  end

  if type(conf.setup) == "function" then
    conf.setup(require_plugin)
  elseif type(conf.setup) == "table" then
    require_plugin().setup(conf.setup)
  end
end

local function pack_update()
  vim.pack.update()
end

local function pack_status()
  local plugins = vim.pack.get()
  for _, plugin in ipairs(plugins) do
    print("Plugin: " .. plugin.spec.name .. (plugin.active and "" or " (inactive)"))
  end
end

local function pack_clean()
  local plugins = vim.pack.get()
  local inactive = {}
  for _, plugin in ipairs(plugins) do
    if not plugin.active then
      table.insert(inactive, plugin.spec.name)
    end
  end
  vim.pack.del(inactive)
end

-- commands
local commands = {
  PaUpdate = pack_update,
  PaStatus = pack_status,
  PaClean = pack_clean,
}
for name, func in pairs(commands) do
  vim.api.nvim_create_user_command(name, func, { nargs = 0 })
end

-- github helper
local function gh(repo)
  return "https://github.com/" .. repo
end

-- PLUGINS

-- catppuccin theme
pack_add({
  src = gh("catppuccin/nvim"),
  name = "catppuccin",
  setup = function(req)
    req().setup({
      background = { dark = "mocha" },
      flavour = "mocha",
    })
    vim.cmd.colorscheme("catppuccin")
  end,
})

-- undo tree
pack_add({
  src = gh("simnalamburt/vim-mundo"),
  name = "vim-mundo",
  setup = function()
    vim.g.mundo_preview_bottom = 1
  end,
})

pack_add({
  src = gh("nvim-treesitter/nvim-treesitter"),
  name = "nvim-treesitter",
  version = "main",
  setup = function(req)
    req().install({
      "lua",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "html",
      "css",
      "rust",
      "python",
      "bash",
      "toml",
      "yaml",
    })
  end,
})

-- auto cd to project directory
pack_add({
  src = gh("ahmedkhalf/project.nvim"),
  name = "project_nvim",
  setup = {
    detection_methods = { "pattern" },
    patterns = { ".git" },
  },
})

-- icons used in various plugins
pack_add({
  src = gh("nvim-tree/nvim-web-devicons"),
  name = "nvim-web-devicons",
  setup = {},
})

-- copilot
pack_add({
  src = gh("zbirenbaum/copilot.lua"),
  name = "copilot",
  setup = function(req)
    req().setup({
      suggestion = {
        auto_trigger = true,
        enabled = true,
        keymap = {
          accept = "<tab>",
        },
      },
    })
  end,
})
-- LSP diagnostics in a panel (:Trouble)
-- opt. deps: nvim-web-devicons
pack_add({
  src = gh("folke/trouble.nvim"),
  name = "trouble",
  setup = {},
})

-- LSP progress on the bottom right
pack_add({
  src = gh("j-hui/fidget.nvim"),
  name = "fidget",
  setup = {},
})

-- remove the swap file messages
pack_add({
  src = gh("gioele/vim-autoswap"),
  name = "autoswap",
})

-- tpope plugins
pack_add({ src = gh("tpope/vim-fugitive"), name = "vim-fugitive" })
pack_add({ src = gh("tpope/vim-repeat"), name = "vim-repeat" })
pack_add({ src = gh("tpope/vim-commentary"), name = "vim-commentary" })
pack_add({ src = gh("tpope/vim-eunuch"), name = "vim-eunuch" })
-- adjusts 'shiftwidth' and 'expandtab' heuristically
pack_add({ src = gh("tpope/vim-sleuth"), name = "vim-sleuth" })

pack_add({
  src = gh("kylechui/nvim-surround"),
  name = "nvim-surround",
  setup = {},
})

-- auto close pairs
pack_add({
  src = gh("windwp/nvim-autopairs"),
  name = "nvim-autopairs",
  setup = {},
})

-- display marks in the gutter
pack_add({
  src = gh("kshenoy/vim-signature"),
  name = "nvim-signature",
})

-- show git signs in the gutter
pack_add({
  src = gh("lewis6991/gitsigns.nvim"),
  name = "gitsigns",
  setup = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
  },
})

-- use s or S then type two chars to move
-- use s or S again to move to the next match
-- move to a specific one using its char shortcut
pack_add({
  src = "https://codeberg.org/andyg/leap.nvim",
  -- src = gh("ggandor/leap.nvim"),
  name = "leap",
  setup = function(require)
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")
  end,
})

-- for blink.cmp snippets
pack_add({
  src = gh("rafamadriz/friendly-snippets"),
  name = "friendly-snippets",
})

-- blink.cmp: completion menu
pack_add({
  src = gh("saghen/blink.cmp"),
  name = "blink.cmp",
  version = "v1.6.0",
  setup = function(require)
    require().setup({
      completion = {
        documentation = { auto_show = true },
        menu = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        preset = "default",
        ["<c-t>"] = { "select_and_accept" },
        ["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      sources = {
        default = {
          "lsp",
          "path",
          "buffer",
          "snippets",
        },
      },
    })

    -- disable copilot suggestions when BlinkCmp is open
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
})

-- dependencies:
--   "nvim-tree/nvim-web-devicons"
pack_add({
  src = gh("stevearc/oil.nvim"),
  name = "oil",
  setup = function(require)
    require().setup({
      columns = { "icon" },
      view_options = {
        show_hidden = true,
      },
    })
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
      desc = "Open parent directory",
    })
  end,
})

pack_add({
  src = gh("sourcegraph/amp.nvim"),
  name = "amp.nvim",
})

pack_add({
  src = gh("folke/snacks.nvim"),
  name = "snacks",
  setup = function(require)
    require().setup({
      picker = { enabled = true },
      explorer = { enabled = true },
    })

    -- keys
    vim.keymap.set("n", "<c-t>", function()
      Snacks.picker.smart()
    end, { desc = "Smart Find Files" })
  end,
})

pack_add({
  src = gh("stevearc/conform.nvim"),
  name = "conform",
  setup = function(require)
    vim.keymap.set("n", "<leader>r", function()
      require().format({ async = true })
    end, {
      desc = "Format buffer",
    })

    local filetype_to_extension = {
      javascript = "js",
      typescript = "ts",
      javascriptreact = "jsx",
      typescriptreact = "tsx",
      solidity = "sol",
      jsonc = "json",
      json = "json",
    }
    local dprint_config_files = {
      ".dprint.json",
      ".dprint.jsonc",
      "dprint.json",
      "dprint.jsonc",
    }
    local biome_config_files = {
      ".biome.json",
      ".biome.jsonc",
      "biome.json",
      "biome.jsonc",
    }
    local biome_fts = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "typescript",
      "typescriptreact",
    }
    local dprint_fts = {
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "markdown",
      "toml",
      "typescript",
      "typescriptreact",
    }

    local function find_formatter(buffer_num)
      local path = vim.api.nvim_buf_get_name(buffer_num)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer_num })
      if vim.tbl_contains(biome_fts, ft) and vim.fs.root(path, biome_config_files) then
        return "biome"
      end
      if vim.tbl_contains(dprint_fts, ft) and vim.fs.root(path, dprint_config_files) then
        return "dprint"
      end
      return nil
    end

    require().setup({
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        solidity = { "forge" },
        ["_"] = function(buffer_num)
          local formatter = find_formatter(buffer_num)
          if formatter then
            vim.print("Using " .. formatter .. " formatter")
            return { formatter }
          end
          return {}
        end,
      },
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        rustfmt = {},
        forge = {
          command = "forge",
          args = { "fmt", "-r", "-" },
          stdin = true,
        },
        biome = function(buffer_num)
          local filename_arg = "$FILENAME"
          local filename = vim.fs.basename(vim.api.nvim_buf_get_name(buffer_num))

          -- if the filename does not have an extension, set one from the filetype.
          if string.find(filename, ".", 1, true) == nil then
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer_num })
            local extension = filetype_to_extension[ft]
            if extension then
              filename_arg = "$FILENAME." .. extension
            end
          end

          return {
            command = "bun",
            args = { "biome", "format", "--stdin-file-path", filename_arg },
            cwd = require("conform.util").root_file(biome_config_files),
          }
        end,
        dprint = function(buffer_num)
          local filename_arg = "$FILENAME"
          local filename = vim.fs.basename(vim.api.nvim_buf_get_name(buffer_num))

          -- if the filename does not have an extension, set one from the filetype.
          if string.find(filename, ".", 1, true) == nil then
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer_num })
            local extension = filetype_to_extension[ft]
            if extension then
              filename_arg = "$FILENAME." .. extension
            end
          end

          return {
            command = "dprint",
            args = { "fmt", "--stdin", filename_arg },
          }
        end,
      },
    })
  end,
})

pack_add({
  src = gh("mikesmithgh/kitty-scrollback.nvim"),
  name = "kitty-scrollback",
  setup = function(require)
    require().setup()
  end,
})
