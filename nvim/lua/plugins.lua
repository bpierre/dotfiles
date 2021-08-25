function reapply_colorscheme()
  vim.cmd('colorscheme ' .. vim.api.nvim_exec('colorscheme', true))
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
  use 'norcalli/nvim-colorizer.lua'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true }
      }
    end
  }

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

  -- status bar
  use {
    'itchyny/lightline.vim',
    config = function() vim.g.lightline = { colorscheme = 'wombat' } end
  }

  -- everything completion
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- start screen
  use {
    'mhinz/vim-startify',
    config = function()

      -- start startify lists at 1
      vim.g.startify_custom_indices = vim.fn.map(vim.fn.range(1, 100),
                                                 'string(v:val)')
      vim.g.startify_custom_header = {}
      -- faster (but might miss some files)
      vim.g.startify_enable_unsafe = 1
      vim.g.startify_change_to_vcs_root = 0
      vim.g.startify_change_to_dir = 1
    end
  }

  -- better matchit (matchit is part of neovim)
  use { 'andymass/vim-matchup', event = 'VimEnter' }

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
      require('telescope').setup {
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
          file_ignore_patterns = {
            "pkg/kit%-legacy", "pkg/website", "pkg/demo", "node_modules",
            "**/*.png", "**/*.jpg", "**/*.gif", "**/*.woff2", "**/*.mp4"
          }
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
      local prettier = {
        function()
          return {
            exe = "prettier",
            args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true
          }
        end
      }
      local luaFmt = {
        function()
          return {
            exe = "lua-format",
            args = {
              "--indent-width=2 --spaces-inside-table-braces --break-after-operator"
            },
            stdin = true
          }
        end
      }
      require('formatter').setup {
        logging = false,
        filetype = {
          html = prettier,
          markdown = prettier,
          json = prettier,
          typescript = prettier,
          typescriptreact = prettier,
          javascriptreact = prettier,
          javascript = prettier,
          solidity = prettier,
          lua = luaFmt
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
