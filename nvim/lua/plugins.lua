function put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function put_text(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, '\n'), '\n')
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

return require('packer').startup(function()

  use 'wbthomason/packer.nvim'

  -- TO TRY
  --
  -- Use vim-floaterm:
  -- - http://jacobzelko.com/workflow/
  -- - https://gist.github.com/TheCedarPrince/7b9b51af4c146880f17c39407815b594
  --
  -- https://github.com/numtostr/FTerm.nvim
  -- https://github.com/machakann/vim-sandwich
  -- https://github.com/machakann/vim-highlightedyank

  -- coloration
  -- use 'gruvbox-community/gruvbox'
  use {
    'eddyekofo94/gruvbox-flat.nvim',
    config = function()
      vim.g.gruvbox_transparent = true
      vim.g.gruvbox_flat_style = "hard"
      reapply_colorscheme()
    end
  }

  -- code screenshots
  use {
    'krivahtoo/silicon.nvim',
    run = './install.sh',
    config = function()
      require('silicon').setup {
        -- font = 'FantasqueSansMono Nerd Font=16',
        theme = 'Dracula'
      }
    end
  }

  -- use 'norcalli/nvim-colorizer.lua'

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '2a63ea5665a6de96acd31a045d9d4d73272ff5a9',
    run = function()
      require('nvim-treesitter.install').update { with_sync = true }
    end,
    config = function()
      require('nvim-treesitter.configs').setup {
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
      }
    end
  }

  use 'danro/rename.vim'

  -- undo tree
  use {
    'simnalamburt/vim-mundo',
    cmd = { 'MundoToggle' },
    config = function() vim.g.mundo_preview_bottom = 1 end
  }

  -- use :WhichKey to check the bindings
  use { 'folke/which-key.nvim', cmd = { 'WhichKey' } }

  -- remove the swap file messages
  use 'gioele/vim-autoswap'

  use {
    'ygm2/rooter.nvim',
    config = function()
      vim.g.rooter_pattern = { '.git', 'node_modules' }
      vim.g.outermost_root = true
    end
  }

  use { 'alvarosevilla95/luatab.nvim', requires = 'kyazdani42/nvim-web-devicons' }

  -- status bar
  --
  -- use {
  --   'itchyny/lightline.vim',
  --   config = function() vim.g.lightline = { colorscheme = 'wombat' } end
  -- }
  -- use {
  --   'nvim-lualine/lualine.nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  -- }
  -- use { 'famiu/feline.nvim', config = function() require('feline').setup() end }

  -- everything completion
  -- use { 'neoclide/coc.nvim', branch = 'release' }

  use 'neovim/nvim-lspconfig'

  use {
    'simrat39/rust-tools.nvim',
    requires = { 'neovim/nvim-lspconfig' },
    config = function()

      -- config from https://sharksforarms.dev/posts/neovim-rust/
      local nvim_lsp = require 'lspconfig'
      require('rust-tools').setup {
        tools = { -- rust-tools options
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
          }
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = on_attach,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
              -- enable clippy on save
              checkOnSave = { command = "clippy" }
            }
          }
        }
      }
    end
  }

  -- Display LSP progress on the bottom right
  use { "j-hui/fidget.nvim", config = function() require"fidget".setup() end }

  -- Completion
  -- Sources
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      local mapping = require('cmp.config.mapping')
      local types = require('cmp.types')
      cmp.setup {
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
      }
    end
  }

  -- use {
  --   'ms-jpq/coq_nvim',
  --   branch = 'coq',
  --   config = function()
  --     vim.g.coq_settings = {
  --       auto_start = 'shut-up',
  --       xdg = true,
  --       clients = {
  --         lsp = { resolve_timeout = 0.02 },
  --         tree_sitter = { slow_threshold = 0.025 },
  --         buffers = { match_syms = true, same_filetype = true }
  --       },
  --       limits = { completion_auto_timeout = 0.05 },
  --       keymap = { jump_to_mark = "", manual_complete = "<c-space>" }
  --     }

  --     local lsp = require "lspconfig"
  --     local coq = require "coq"
  --     lsp.tsserver.setup(coq.lsp_ensure_capabilities())

  --     -- vim.g.coq_settings.keymap.jump_to_mark = nil
  --     -- vim.g.coq_settings.keymap.manual_complete = "<c-space>"
  --   end
  -- }
  -- use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }

  use 'onsails/lspkind-nvim'
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-nvim-lua"
  use "quangnguyen30192/cmp-nvim-ultisnips"

  -- use "hrsh7th/cmp-nvim-lsp-document-symbol"
  -- use "saadparwaiz1/cmp_luasnip"
  -- use "tamago324/cmp-zsh"

  -- use({
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     require("lsp_lines").register_lsp_virtual_lines()
  --   end,
  -- })

  -- -- Disable virtual_text since it's redundant due to lsp_lines.
  -- vim.diagnostic.config({
  --   virtual_text = false,
  -- })

  use {
    "ggandor/lightspeed.nvim",
    config = function() require('lightspeed').setup {} end
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- use 'vim-denops/denops.vim'
  -- use {
  --   "Shougo/ddc.vim",
  --   requires = { "Shougo/ddc-around", "Shougo/ddc-nvim-lsp" }
  -- }

  -- use {
  --   'jose-elias-alvarez/nvim-lsp-ts-utils',
  --   requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require("lspconfig").tsserver.setup {
  --       on_attach = function(client, bufnr)
  --         local ts_utils = require("nvim-lsp-ts-utils")

  --         ts_utils.setup {
  --           enable_import_on_completion = true,

  --           -- lower numbers = higher priority
  --           import_all_priorities = {
  --             same_file = 1, -- add to existing import statement
  --             local_files = 2, -- git files or files with relative path markers
  --             buffer_content = 3, -- loaded buffer content
  --             buffers = 4 -- loaded buffer names
  --           },
  --           always_organize_imports = true,

  --           -- update imports on file move
  --           update_imports_on_move = false,
  --           require_confirmation_on_move = false,
  --           watch_dir = nil
  --         }

  --         -- required to fix code action ranges and filter diagnostics
  --         ts_utils.setup_client(client)

  --         -- no default maps, so you may want to define some here
  --         -- local opts = { silent = true }
  --         -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>",
  --         --                             opts)
  --         -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>",
  --         --                             opts)
  --         -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>",
  --         --                             opts)
  --       end
  --     }
  --   end
  -- }

  -- start screen
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').opts)
    end
  }

  -- better matchit (matchit is part of neovim)
  -- edit: disabled because of errors with nvim-treesitter
  -- use { 'andymass/vim-matchup', event = 'VimEnter' }

  -- display marks in the gutter
  use 'kshenoy/vim-signature'

  -- git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- tpope essentials
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- tmux interaction
  use {
    'benmills/vimux',
    config = function()
      vim.g.VimuxUseNearestPane = 1
      vim.g.VimuxOrientation = "v"
      vim.g.VimuxHeight = "15"
    end
  }

  -- use {
  --   'abecodes/tabout.nvim',
  --   config = function()
  --     require('tabout').setup {
  --       tabkey = '<Tab>',
  --       backwards_tabkey = '<S-Tab>',
  --       act_as_tab = true,
  --       act_as_shift_tab = false,
  --       enable_backwards = true,
  --       completion = true,
  --       tabouts = {
  --         { open = "'", close = "'" }, { open = '"', close = '"' },
  --         { open = '`', close = '`' }, { open = '(', close = ')' },
  --         { open = '[', close = ']' }, { open = '{', close = '}' }
  --       },
  --       ignore_beginning = true
  --     }
  --   end,
  --   wants = { 'nvim-treesitter' }
  -- }

  use {
    'SirVer/ultisnips',
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
    end,
    { 'honza/vim-snippets' }
  }

  -- adjusts 'shiftwidth' and 'expandtab' heuristically
  use 'tpope/vim-sleuth'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    cmd = { "Telescope" },
    requires = 'nvim-lua/plenary.nvim',
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
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    after = 'telescope.nvim',
    run = 'make',
    config = function() require('telescope').load_extension('fzf') end
  }
  use {
    'nvim-telescope/telescope-fzy-native.nvim',
    requires = 'nvim-telescope/telescope.nvim',
    after = 'telescope.nvim',
    config = function() require('telescope').load_extension('fzy_native') end
  }
  use {
    'AckslD/nvim-neoclip.lua',
    requires = 'nvim-telescope/telescope.nvim',
    after = 'telescope.nvim',
    config = function()
      require('neoclip').setup()
      require('telescope').load_extension('neoclip')
    end
  }

  -- prettier etc.
  use {
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

          -- Default to prettier for now
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
        function() return { exe = "rustfmt", args = {}, stdin = true } end
      }
      local forge_fmt = {
        function()
          return { exe = "forge fmt", args = { "--raw", "-" }, stdin = true }
        end
      }
      require('formatter').setup {
        logging = false,
        filetype = {
          css = prettier,
          html = prettier,
          markdown = prettier_or_dprint,
          json = prettier_or_dprint,
          typescript = prettier_or_dprint,
          typescriptreact = prettier_or_dprint,
          javascriptreact = prettier_or_dprint,
          javascript = prettier_or_dprint,
          solidity = prettier_or_dprint,
          lua = luafmt,
          rust = rustfmt,
          solidity = forge_fmt
        }
      }
    end
  }

  -- languages
  use { 'justinj/vim-pico8-syntax', ft = { 'lua', 'pico8' } }
  use { 'rust-lang/rust.vim', ft = { 'rust' } }
  use { 'tomlion/vim-solidity', ft = { 'solidity' } }
  use { 'vim-scripts/nginx.vim', ft = { 'nginx' } }
  use { 'zah/nim.vim', ft = { 'nim' } }
  use { 'tikhomirov/vim-glsl', ft = { 'glsl' } }
  use {
    'plasticboy/vim-markdown',
    ft = { 'markdown' },
    config = function()
      vim.g.vim_markdown_fenced_languages = {
        'jsx=javascript', 'ts=typescript', 'tsx=typescript'
      }
    end
  }

  -- JS
  local jsts = {
    'javascript', 'javascriptreact', 'typescript', 'typescriptreact'
  }
  use { 'jparise/vim-graphql', ft = vim.list_extend(jsts, { 'graphql' }) }
  use { 'heavenshell/vim-jsdoc', ft = jsts }
  use { 'jxnblk/vim-mdx-js', ft = jsts }
  use { 'moll/vim-node', ft = jsts }
  use { 'posva/vim-vue', ft = { 'vue' } }
  use { 'evanleck/vim-svelte', branch = 'main', ft = { 'svelte' } }

end)
