-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

--
-- TO TRY
--
-- Use vim-floaterm:
-- - http://jacobzelko.com/workflow/
-- - https://gist.github.com/TheCedarPrince/7b9b51af4c146880f17c39407815b594
--
-- https://github.com/numtostr/FTerm.nvim
-- https://github.com/machakann/vim-sandwich
-- https://github.com/machakann/vim-highlightedyank
-- code screenshots
-- use {
--   'krivahtoo/silicon.nvim',
--   run = './install.sh',
--   config = function()
--     require('silicon').setup {
--       -- font = 'FantasqueSansMono Nerd Font=16',
--       theme = 'Dracula'
--     }
--   end
-- }
-- JS
local jsts_file_types = {
  'javascript', 'javascriptreact', 'typescript', 'typescriptreact'
}

require("lazy").setup({
  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require("gruvbox").setup({ contrast = "hard", transparent_mode = false })
    end
  }, {

    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        additional_vim_regex_highlighting = true,
        auto_install = true,
        sync_install = true,
        ensure_installed = {
          "bash", "c", "c_sharp", "clojure", "cmake", "comment", "commonlisp",
          "cpp", "css", "dart", "dockerfile", "dot", "elixir", "elm", "elvish",
          "embedded_template", "erlang", "fennel", "fish", "gitattributes",
          "gitignore", "glsl", "go", "graphql", "haskell", "help", "html",
          "http", "java", "javascript", "jsdoc", "json", "json5", "kotlin",
          "latex", "llvm", "lua", "make", "markdown", "markdown_inline", "nix",
          "ocaml", "ocaml_interface", "ocamllex", "perl", "php", "phpdoc",
          "prisma", "python", "qmljs", "regex", "ruby", "rust", "solidity",
          "sql", "svelte", "swift", "sxhkdrc", "toml", "tsx", "typescript",
          "vim", "vue", "yaml", "zig"
        },
        highlight = { enable = true, additional_vim_regex_highlighting = true },
        indent = { enable = true }
      })
    end
  }, {
    -- rename.vim
    'danro/rename.vim'
  }, {
    -- undo tree
    'simnalamburt/vim-mundo',
    cmd = { 'MundoToggle' },
    config = function() vim.g.mundo_preview_bottom = 1 end
  }, {
    -- use :WhichKey to check the bindings
    'folke/which-key.nvim',
    cmd = { 'WhichKey' }
  }, {
    -- remove the swap file messages
    'gioele/vim-autoswap'
  }, {
    'ygm2/rooter.nvim',
    config = function()
      vim.g.rooter_pattern = { '.git', 'node_modules' }
      vim.g.outermost_root = true
    end
  }, {
    'alvarosevilla95/luatab.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  }, {
    -- lspconfig
    'neovim/nvim-lspconfig'
  }, {
    -- adds rust-specific functionality to lsp, sets up rust-analyzer
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function() require"rust-tools".setup() end
  }, {
    -- Display LSP progress on the bottom right
    "j-hui/fidget.nvim",
    tag = 'legacy',
    config = function() require"fidget".setup() end
  }, {
    -- LSP diagnostics in a panel (:Trouble)
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("trouble").setup() end
  }, {
    -- Completion menu
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      local mapping = require('cmp.config.mapping')
      local types = require('cmp.types')
      cmp.setup({
        mapping = {
          -- ["<C-d>"] = mapping.scroll_docs(-4),
          -- ["<C-f>"] = mapping.scroll_docs(4),
          -- ["<C-e>"] = mapping.close(),

          ['<C-n>'] = mapping(mapping.select_next_item({
            behavior = types.cmp.SelectBehavior.Insert
          }), { 'i', 'c' }),

          ['<C-p>'] = mapping(mapping.select_prev_item({
            behavior = types.cmp.SelectBehavior.Insert
          }), { 'i', 'c' }),

          ["<c-y>"] = mapping(mapping.confirm {
            behavior = types.cmp.ConfirmBehavior.Insert,
            select = true
          }, { "i", "c" }),

          ["<c-space>"] = mapping {
            i = mapping.complete(),
            c = function(_ --[[fallback]] )
              if cmp.visible() then
                if not cmp.confirm { select = true } then return end
              else
                cmp.complete()
              end
            end
          },
          ["<tab>"] = cmp.config.disable
          -- ['<CR>'] = mapping.confirm({ select = true })
        },
        sources = {
          { name = "nvim_lua" }, { name = "nvim_lsp" }, { name = "path" },
          { name = "ultisnips" }, { name = "buffer", keyword_length = 5 }
        },
        sorting = {
          comparators = {
            compare.offset, compare.exact, compare.score, compare.kind,
            compare.sort_text, compare.length, compare.order
          }
        },
        snippet = {
          expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
        },
        formatting = {
          format = require('lspkind').cmp_format {
            with_text = true,
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[lsp]",
              nvim_lua = "[api]",
              path = "[path]",
              luasnip = "[snip]"
            }
          }
        }

        -- experimental = { native_menu = false, ghost_text = true }
      })
    end
  }, {
    -- pictograms for lsp
    'onsails/lspkind-nvim'
  }, {
    -- cmp: lsp
    "hrsh7th/cmp-nvim-lsp"
  }, {
    -- cmp: buffers
    "hrsh7th/cmp-buffer"
  }, {
    -- cmp: paths
    "hrsh7th/cmp-path"
  }, {
    -- cmp: neovim lua API
    "hrsh7th/cmp-nvim-lua"
  }, {
    -- cmp: ultisnips
    "quangnguyen30192/cmp-nvim-ultisnips"
  }, {
    "ggandor/lightspeed.nvim",
    config = function() require('lightspeed').setup({}) end
  }, {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup() end
  }, {
    -- start screen
    'goolord/alpha-nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').opts)
    end
  }, {}, {
    -- display marks in the gutter
    'kshenoy/vim-signature'
  }, {
    -- git
    'tpope/vim-fugitive'
  }, {
    -- git gutter
    'airblade/vim-gitgutter'
  }, {
    -- tpope repeat
    'tpope/vim-repeat'
  }, {
    -- tpope surround
    'tpope/vim-surround'
  }, {
    -- tpope surround
    'tpope/vim-commentary'
  }, {
    -- tmux interaction
    'benmills/vimux',
    config = function()
      vim.g.VimuxUseNearestPane = 1
      vim.g.VimuxOrientation = "v"
      vim.g.VimuxHeight = "15"
    end
  }, {
    'SirVer/ultisnips',
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
    end,
    dependencies = { 'honza/vim-snippets' }
  }, {
    -- adjusts 'shiftwidth' and 'expandtab' heuristically
    'tpope/vim-sleuth'
  }, {
    -- telescope
    'nvim-telescope/telescope.nvim',
    cmd = { "Telescope" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local telescope_actions = require('telescope.actions')
      telescope.setup {
        layout_strategy = 'center',
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true -- override the file sorter
          }
        },
        defaults = {
          -- Lua regex patterns: http://www.lua.org/pil/20.2.html
          -- "pkg/demo",
          -- file_ignore_patterns = {
          --   "pkg/kit%-legacy", "pkg/website", "node_modules", "**/*.png",
          --   "**/*.jpg", "**/*.gif", "**/*.woff2", "**/*.mp4"
          -- },
          file_ignore_patterns = {
            "node_modules", "**/*.png", "**/*.jpg", "**/*.gif", "**/*.woff2",
            "**/*.mp4"
          },
          mappings = { n = { ["<C-t>"] = telescope_actions.select_tab } }
        }
      }
    end
  }, {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = 'make',
    config = function() require('telescope').load_extension('fzf') end
  }, {
    'nvim-telescope/telescope-fzy-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function() require('telescope').load_extension('fzy_native') end
  }, {
    'AckslD/nvim-neoclip.lua',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('neoclip').setup()
      require('telescope').load_extension('neoclip')
    end
  }, {
    -- prettier etc.
    'mhartington/formatter.nvim',
    config = function()
      local prettier_or_dprint = {
        function()
          local utils = require('nvim-tree-utils')

          local buffer_dir = vim.fn.expand('%:p:h')
          local buffer_name = vim.api.nvim_buf_get_name(0)

          local parts = {}
          for part in string.gmatch(buffer_dir, "[^/]+") do
            table.insert(parts, part)
          end

          local args_prettier =
              { "--stdin-filepath", '"' .. buffer_name .. '"' }
          local args_dprint = { "fmt", "--stdin", '"' .. buffer_name .. '"' }

          -- Default to prettier
          -- local exe = "prettier"
          -- local args = args_prettier

          -- Default to dprint now
          local exe = "dprint"
          local args = args_dprint

          for i = #parts, 1, -1 do
            local bin_path = '/' .. utils.path_join({ unpack(parts, 1, i) }) ..
                                 "/node_modules/.bin/"

            if utils.file_exists(bin_path .. "dprint") then
              exe = bin_path .. "dprint"
              args = args_dprint
              break
            end

            if utils.file_exists(bin_path .. "prettier") then
              exe = bin_path .. "prettier"
              args = args_prettier
              break
            end
          end

          return { exe = exe, args = args, stdin = true }
        end
      }
      local prettier = {
        function()
          return {
            exe = "prettier",
            args = {
              "--stdin-filepath", '"' .. vim.api.nvim_buf_get_name(0) .. '"'
            },
            stdin = true
          }
        end
      }
      local dprint = {
        function()
          return {
            exe = "dprint",
            args = {
              "fmt", "--stdin", '"' .. vim.api.nvim_buf_get_name(0) .. '"'
            },
            stdin = true
          }
        end
      }
      local luafmt = {
        function()
          return {
            exe = "lua-format",
            args = {
              "--indent-width=2", "--spaces-inside-table-braces",
              "--break-after-operator"
            },
            stdin = true
          }
        end
      }
      local rustfmt = {
        function()
          return
              { exe = "rustfmt", args = { "--edition", "2021" }, stdin = true }
        end
      }
      local forge_fmt = {
        function()
          return { exe = "forge fmt", args = { "--raw", "-" }, stdin = true }
        end
      }
      require('formatter').setup({
        logging = false,
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
          lua = luafmt,
          rust = rustfmt,
          solidity = forge_fmt,
          toml = dprint
        }
      })
    end
  }, -- languages
  { 'terrastruct/d2-vim', ft = { 'd2' } },
  { 'justinj/vim-pico8-syntax', ft = { 'lua', 'pico8' } },
  { 'rust-lang/rust.vim', ft = { 'rust' } },
  { 'tomlion/vim-solidity', ft = { 'solidity' } },
  { 'vim-scripts/nginx.vim', ft = { 'nginx' } },
  { 'zah/nim.vim', ft = { 'nim' } }, { 'tikhomirov/vim-glsl', ft = { 'glsl' } },
  {
    'plasticboy/vim-markdown',
    ft = { 'markdown' },
    config = function()
      vim.g.vim_markdown_fenced_languages = {
        'jsx=javascript', 'ts=typescript', 'tsx=typescript'
      }
    end
  },
  { 'jparise/vim-graphql', ft = vim.list_extend(jsts_file_types, { 'graphql' }) },
  { 'heavenshell/vim-jsdoc', ft = jsts_file_types },
  { 'jxnblk/vim-mdx-js', ft = jsts_file_types },
  { 'moll/vim-node', ft = jsts_file_types },
  { 'posva/vim-vue', ft = { 'vue' } },
  { 'evanleck/vim-svelte', branch = 'main', ft = { 'svelte' } },
  { 'github/copilot.vim' }
})
