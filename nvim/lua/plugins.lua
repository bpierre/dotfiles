local secrets = require("secrets")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins to try:
-- https://github.com/machakann/vim-sandwich
-- https://github.com/machakann/vim-highlightedyank
-- https://github.com/ray-x/aurora

-- JS
local js_ts_file_types = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

-- Some files don’t have an extension, which some tools (e.g. formatters)
-- require to determine file types. This is a mapping from known filetypes
-- to extensions, which can be used in those cases.
local filetype_to_extension = {
  javascript = "js",
  typescript = "ts",
  javascriptreact = "jsx",
  typescriptreact = "tsx",
  solidity = "sol",
  jsonc = "json",
  json = "json",
}

local lazy_opts = {
  checker = {
    enable = true,
  },
  rocks = {
    enabled = false,
  },
}

local lazy_plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = { dark = "mocha" },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        additional_vim_regex_highlighting = true,
        auto_install = true,
        sync_install = true,
        ensure_installed = {
          "bash",
          "c",
          "comment",
          "cpp",
          "css",
          "dockerfile",
          "dot",
          "embedded_template",
          "gitattributes",
          "gitignore",
          "glsl",
          "go",
          "graphql",
          "vimdoc",
          "html",
          "http",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "nix",
          "prisma",
          "python",
          "regex",
          "ruby",
          "rust",
          "solidity",
          "svelte",
          "swift",
          "sxhkdrc",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vue",
          "yaml",
          "zig",
        },
        highlight = { enable = true, additional_vim_regex_highlighting = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- display LSP progress on the bottom right
  { "j-hui/fidget.nvim", tag = "legacy" },

  -- LSP diagnostics in a panel (:Trouble)
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- undo tree
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    config = function()
      vim.g.mundo_preview_bottom = 1
    end,
  },

  -- remove the swap file messages
  "gioele/vim-autoswap",

  {
    "ygm2/rooter.nvim",
    config = function()
      vim.g.rooter_pattern = { ".git", "node_modules" }
      vim.g.outermost_root = true
    end,
  },

  "tiagovla/scope.nvim",

  -- completion menu
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "onsails/lspkind-nvim" },
    config = function()
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local mapping = require("cmp.config.mapping")
      local types = require("cmp.types")
      cmp.setup({
        mapping = {
          ["<C-n>"] = mapping(
            mapping.select_next_item({
              behavior = types.cmp.SelectBehavior.Insert,
            }),
            { "i", "c" }
          ),
          ["<C-p>"] = mapping(
            mapping.select_prev_item({
              behavior = types.cmp.SelectBehavior.Insert,
            }),
            { "i", "c" }
          ),
          ["<c-y>"] = mapping(
            mapping.confirm({
              behavior = types.cmp.ConfirmBehavior.Insert,
              select = true,
            }),
            { "i", "c" }
          ),
          ["<c-space>"] = mapping({
            i = mapping.complete(),
            c = function(_)
              if cmp.visible() then
                if not cmp.confirm({ select = true }) then
                  return
                end
              else
                cmp.complete()
              end
            end,
          }),
          ["<tab>"] = cmp.config.disable,
        },
        sources = {
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer", keyword_length = 5 },
        },
        sorting = {
          comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        formatting = {
          format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[lsp]",
              nvim_lua = "[api]",
              path = "[path]",
              luasnip = "[snip]",
            },
          }),
        },
      })
    end,
  },

  -- cmp completions
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",

  -- start screen
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").opts)
    end,
  },

  -- display marks in the gutter
  "kshenoy/vim-signature",

  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = { markdown = true }
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      mappings = {
        ask = "<leader>aa",
        refresh = "<leader>ar",
        edit = "<leader>ae",
      },
    },
    build = ":AvanteBuild",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- optional:
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
      {
        -- Make sure to setup it properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "Avante" }, -- only Avante (no "markdown")
        },
        ft = { "Avante" }, -- only Avante (no "markdown")
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
      })
    end,
  },

  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  {
    "tpope/vim-surround",
    event = "BufEnter",
    config = function()
      vim.g.surround_no_mappings = 1
      vim.keymap.set("n", "ds", "<Plug>Dsurround", { silent = true })
      vim.keymap.set("n", "cs", "<Plug>Csurround", { silent = true })
      vim.keymap.set("i", "<C-S>", "<Plug>Isurround", { silent = true })
    end,
  },
  "tpope/vim-commentary",
  "tpope/vim-eunuch",
  "tpope/vim-sleuth", -- adjusts 'shiftwidth' and 'expandtab' heuristically

  -- use s or S then type two chars to move
  -- use s or S again to move to the next match
  -- move to a specific one using its char shortcut
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").create_default_mappings()
    end,
  },

  -- use f or F then type a char to move
  -- move to the next one with f or F
  "rhysd/clever-f.vim",

  -- tmux interaction
  {
    "benmills/vimux",
    config = function()
      vim.g.VimuxUseNearestPane = 1
      vim.g.VimuxOrientation = "v"
      vim.g.VimuxHeight = "15"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        layout_strategy = "center",
        defaults = {
          -- Lua regex patterns: http://www.lua.org/pil/20.2.html
          file_ignore_patterns = {
            "node_modules",
            "**/*.png$",
            "**/*.jpg$",
            "**/*.gif$",
            "**/*.woff2$",
            "**/*.mp4$",
          },
          mappings = {
            n = { ["<C-t>"] = require("telescope.actions").select_tab },
            i = {
              ["<cr>"] = function(bufnr)
                require("telescope.actions.set").edit(bufnr, "drop")
              end,
            },
          },
        },
      })
    end,
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("neoclip")
      require("neoclip").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufEnter" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>r",
        mode = "n",
        desc = "Format buffer",
        function()
          require("conform").format({ async = true })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        solidity = { "forge" },
        ["_"] = function(bufnr)
          local dprint_fts = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "jsonc",
            "markdown",
            "toml",
            "html",
            "css",
            "graphql",
          }
          local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
          if vim.tbl_contains(dprint_fts, ft) then
            return { "dprint" }
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
        dprint = function(bufnr)
          local filename_arg = "$FILENAME"

          local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
          if string.find(filename, ".", 1, true) == nil then
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            local extension = filetype_to_extension[ft]
            if extension then
              filename_arg = "$FILENAME." .. extension
            end
          end

          return {
            command = "dprint",
            args = { "fmt", "--stdin", filename_arg },
            cwd = require("conform.util").root_file({
              "dprint.json",
              ".dprint.json",
              "dprint.jsonc",
              ".dprint.jsonc",
            }),
          }
        end,
      },
    },
  },

  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },

  -- languages
  { "terrastruct/d2-vim", ft = { "d2" } },
  { "justinj/vim-pico8-syntax", ft = { "lua", "pico8" } },
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "tomlion/vim-solidity", ft = { "solidity" } },
  { "vim-scripts/nginx.vim", ft = { "nginx" } },
  { "zah/nim.vim", ft = { "nim" } },
  { "tikhomirov/vim-glsl", ft = { "glsl" } },

  {
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    config = function()
      vim.g.vim_markdown_fenced_languages = {
        "jsx=javascript",
        "ts=typescript",
        "tsx=typescript",
      }
    end,
  },
  { "jparise/vim-graphql", ft = vim.list_extend(js_ts_file_types, { "graphql" }) },
  { "heavenshell/vim-jsdoc", ft = js_ts_file_types },
  { "jxnblk/vim-mdx-js", ft = js_ts_file_types },
  { "moll/vim-node", ft = js_ts_file_types },
  { "posva/vim-vue", ft = { "vue" } },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
        desc = "Open parent directory",
      })
    end,
  },
}

require("lazy").setup(lazy_plugins, lazy_opts)
