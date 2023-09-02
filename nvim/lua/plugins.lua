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

-- JS
local js_ts_file_types = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

local lazy_config = {
  defaults = {
    -- lazy = true,
  },
}

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "hard",
      transparent_mode = false,
    },
  },
  {
    "bpierre/carbon-now.nvim",
    branch = "language-map",
    -- dir = "~/d/carbon-now.nvim",
    cmd = "CarbonNow",
    lazy = true,
    config = true,
  },
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({
        with_sync = true,
      })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        additional_vim_regex_highlighting = true,
        auto_install = true,
        sync_install = true,
        ensure_installed = {
          "bash",
          "c",
          "c_sharp",
          "clojure",
          "cmake",
          "comment",
          "commonlisp",
          "cpp",
          "css",
          "dart",
          "dockerfile",
          "dot",
          "elixir",
          "elm",
          "elvish",
          "embedded_template",
          "erlang",
          "fennel",
          "fish",
          "gitattributes",
          "gitignore",
          "glsl",
          "go",
          "graphql",
          "haskell",
          "help",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "kotlin",
          "latex",
          "llvm",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "nix",
          "ocaml",
          "ocaml_interface",
          "ocamllex",
          "perl",
          "php",
          "phpdoc",
          "prisma",
          "python",
          "qmljs",
          "regex",
          "ruby",
          "rust",
          "solidity",
          "sql",
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

  -- undo tree
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    config = function()
      vim.g.mundo_preview_bottom = 1
    end,
  },

  -- a better which-key
  {
    "Cassin01/wf.nvim",
    version = "*",
    config = function()
      require("wf").setup()
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

  {
    "alvarosevilla95/luatab.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = true,
  },

  "neovim/nvim-lspconfig",

  -- adds rust-specific functionality to lsp, sets up rust-analyzer
  { "simrat39/rust-tools.nvim", dependencies = { "neovim/nvim-lspconfig" } },

  -- display LSP progress on the bottom right
  { "j-hui/fidget.nvim", tag = "legacy" },

  -- LSP diagnostics in a panel (:Trouble)
  { "folke/trouble.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },

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
          { name = "ultisnips" },
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
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
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
  "quangnguyen30192/cmp-nvim-ultisnips",

  -- start screen
  {
    "goolord/alpha-nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").opts)
    end,
  },

  -- display marks in the gutter
  "kshenoy/vim-signature",

  "github/copilot.vim",
  "danro/rename.vim",
  "ggandor/lightspeed.nvim",
  "windwp/nvim-autopairs",
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-commentary",

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
    "SirVer/ultisnips",
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
    end,
    dependencies = { "honza/vim-snippets" },
  },

  -- adjusts 'shiftwidth' and 'expandtab' heuristically
  "tpope/vim-sleuth",

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
            "**/*.png",
            "**/*.jpg",
            "**/*.gif",
            "**/*.woff2",
            "**/*.mp4",
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
    "mhartington/formatter.nvim",
    config = function()
      local function conf(fn)
        return {
          function()
            return fn(vim.api.nvim_buf_get_name(0))
          end,
        }
      end
      local prettier = conf(function(path)
        return {
          exe = "prettier",
          args = {
            "--stdin-filepath",
            '"' .. path .. '"',
          },
          stdin = true,
        }
      end)
      local dprint = conf(function(path)
        return {
          exe = "dprint",
          args = {
            "fmt",
            "--stdin",
            '"' .. path .. '"',
          },
          stdin = true,
        }
      end)
      local stylua = conf(function()
        return {
          exe = "stylua",
          args = {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "-",
          },
          stdin = true,
        }
      end)
      local rustfmt = conf(function()
        return {
          exe = "rustfmt",
          args = { "--edition", "2021" },
          stdin = true,
        }
      end)
      local forgefmt = conf(function()
        return {
          exe = "forge fmt",
          args = { "--raw", "-" },
          stdin = true,
        }
      end)
      -- formatter.nvim obviously doesn’t need to be here,
      -- but it’s nice to keep all the formatters together.
      local zigfmt = conf(function()
        vim.fn["zig#fmt#Format"]()
        return {}
      end)

      require("formatter").setup({
        filetype = {
          css = prettier,
          html = prettier,
          markdown = dprint,
          json = dprint,
          jsonc = dprint,
          typescript = dprint,
          typescriptreact = dprint,
          javascriptreact = dprint,
          javascript = dprint,
          solidity = dprint,
          lua = stylua,
          rust = rustfmt,
          solidity = forgefmt,
          toml = dprint,
          zig = zigfmt,
        },
        logging = false,
      })
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
    "ziglang/zig.vim",
    ft = { "zig" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      vim.g.zig_fmt_autosave = 0

      local lspconfig = require("lspconfig")
      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        require("completion").on_attach()
      end

      local servers = { "zls" }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({ on_attach = on_attach })
      end
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
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
}, lazy_config)
