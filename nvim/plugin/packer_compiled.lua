-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/pierre/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/pierre/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/pierre/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/pierre/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/pierre/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/coc.nvim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\nÄ\1\0\0\5\0\6\1\n5\0\0\0005\1\1\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0?\2\0\0=\1\5\0L\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\2\0\0\21--stdin-filepath\1\0\2\bexe\rprettier\nstdin\2\5ÄÄ¿ô\4~\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0I--indent-width=2 --spaces-inside-table-braces --break-after-operator\1\0\2\bexe\15lua-format\nstdin\2Ô\1\1\0\6\0\17\0\0244\0\3\0003\1\0\0>\1\1\0004\1\3\0003\2\1\0>\2\1\0016\2\2\0'\4\3\0B\2\2\0029\2\4\0025\4\5\0005\5\6\0=\0\a\5=\0\b\5=\0\t\5=\0\n\5=\0\v\5=\0\f\5=\0\r\5=\0\14\5=\1\15\5=\5\16\4B\2\2\1K\0\1\0\rfiletype\blua\rsolidity\15javascript\20javascriptreact\20typescriptreact\15typescript\tjson\rmarkdown\thtml\1\0\0\1\0\1\flogging\1\nsetup\14formatter\frequire\0\0\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["gruvbox-flat.nvim"] = {
    config = { "\27LJ\2\ny\0\0\2\0\6\0\v6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\5\0B\0\1\1K\0\1\0\24reapply_colorscheme\thard\23gruvbox_flat_style\24gruvbox_transparent\6g\bvim\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/gruvbox-flat.nvim"
  },
  ["lightline.vim"] = {
    config = { "\27LJ\2\nA\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\1\16colorscheme\vwombat\14lightline\6g\bvim\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/lightline.vim"
  },
  ["nginx.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/nginx.vim"
  },
  ["nim.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/nim.vim"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\nf\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\fneoclip\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/nvim-neoclip.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nÉ\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["rust.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/rust.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15fzy_native\19load_extension\14telescope\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    after = { "nvim-neoclip.lua", "telescope-fzf-native.nvim", "telescope-fzy-native.nvim" },
    commands = { "Telescope" },
    config = { "\27LJ\2\n∆\2\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\3=\3\a\0025\3\t\0005\4\b\0=\4\n\3=\3\v\2B\0\2\1K\0\1\0\rdefaults\25file_ignore_patterns\1\0\0\1\n\0\0\20pkg/kit%-legacy\16pkg/website\rpkg/demo\17node_modules\r**/*.png\r**/*.jpg\r**/*.gif\15**/*.woff2\r**/*.mp4\15extensions\bfzf\1\0\0\1\0\3\28override_generic_sorter\1\nfuzzy\2\25override_file_sorter\2\1\0\1\20layout_strategy\vcenter\nsetup\14telescope\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-autoswap"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-autoswap"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-gitgutter"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-gitgutter"
  },
  ["vim-glsl"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-glsl"
  },
  ["vim-graphql"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-graphql"
  },
  ["vim-jsdoc"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-jsdoc"
  },
  ["vim-markdown"] = {
    config = { '\27LJ\2\no\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\4\0\0\19jsx=javascript\18ts=typescript\19tsx=typescript"vim_markdown_fenced_languages\6g\bvim\0' },
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-markdown"
  },
  ["vim-matchup"] = {
    after_files = { "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-mdx-js"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-mdx-js"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle" },
    config = { "\27LJ\2\n6\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\25mundo_preview_bottom\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-mundo"
  },
  ["vim-node"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-node"
  },
  ["vim-pico8-syntax"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-pico8-syntax"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-signature"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-signature"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-snippets"
  },
  ["vim-solidity"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-solidity"
  },
  ["vim-startify"] = {
    config = { "\27LJ\2\nù\2\0\0\a\0\v\0\0316\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\0016\3\0\0009\3\3\0039\3\5\3)\5\1\0)\6d\0B\3\3\2'\4\6\0B\1\3\2=\1\2\0006\0\0\0009\0\1\0004\1\0\0=\1\a\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0)\1\0\0=\1\t\0006\0\0\0009\0\1\0)\1\1\0=\1\n\0K\0\1\0\27startify_change_to_dir startify_change_to_vcs_root\27startify_enable_unsafe\27startify_custom_header\18string(v:val)\nrange\bmap\afn\28startify_custom_indices\6g\bvim\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-svelte"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-svelte"
  },
  ["vim-vue"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/vim-vue"
  },
  vimux = {
    config = { "\27LJ\2\nw\0\0\2\0\a\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\a15\16VimuxHeight\6v\21VimuxOrientation\24VimuxUseNearestPane\6g\bvim\0" },
    loaded = true,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/start/vimux"
  },
  ["which-key.nvim"] = {
    commands = { "WhichKey" },
    loaded = false,
    needs_bufread = false,
    path = "/home/pierre/.local/share/nvim/site/pack/packer/opt/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gruvbox-flat.nvim
time([[Config for gruvbox-flat.nvim]], true)
try_loadstring("\27LJ\2\ny\0\0\2\0\6\0\v6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\5\0B\0\1\1K\0\1\0\24reapply_colorscheme\thard\23gruvbox_flat_style\24gruvbox_transparent\6g\bvim\0", "config", "gruvbox-flat.nvim")
time([[Config for gruvbox-flat.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nÉ\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lightline.vim
time([[Config for lightline.vim]], true)
try_loadstring("\27LJ\2\nA\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\1\16colorscheme\vwombat\14lightline\6g\bvim\0", "config", "lightline.vim")
time([[Config for lightline.vim]], false)
-- Config for: vimux
time([[Config for vimux]], true)
try_loadstring("\27LJ\2\nw\0\0\2\0\a\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\a15\16VimuxHeight\6v\21VimuxOrientation\24VimuxUseNearestPane\6g\bvim\0", "config", "vimux")
time([[Config for vimux]], false)
-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
try_loadstring("\27LJ\2\nÄ\1\0\0\5\0\6\1\n5\0\0\0005\1\1\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0?\2\0\0=\1\5\0L\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\2\0\0\21--stdin-filepath\1\0\2\bexe\rprettier\nstdin\2\5ÄÄ¿ô\4~\0\0\2\0\3\0\0045\0\0\0005\1\1\0=\1\2\0L\0\2\0\targs\1\2\0\0I--indent-width=2 --spaces-inside-table-braces --break-after-operator\1\0\2\bexe\15lua-format\nstdin\2Ô\1\1\0\6\0\17\0\0244\0\3\0003\1\0\0>\1\1\0004\1\3\0003\2\1\0>\2\1\0016\2\2\0'\4\3\0B\2\2\0029\2\4\0025\4\5\0005\5\6\0=\0\a\5=\0\b\5=\0\t\5=\0\n\5=\0\v\5=\0\f\5=\0\r\5=\0\14\5=\1\15\5=\5\16\4B\2\2\1K\0\1\0\rfiletype\blua\rsolidity\15javascript\20javascriptreact\20typescriptreact\15typescript\tjson\rmarkdown\thtml\1\0\0\1\0\1\flogging\1\nsetup\14formatter\frequire\0\0\0", "config", "formatter.nvim")
time([[Config for formatter.nvim]], false)
-- Config for: vim-startify
time([[Config for vim-startify]], true)
try_loadstring("\27LJ\2\nù\2\0\0\a\0\v\0\0316\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\0016\3\0\0009\3\3\0039\3\5\3)\5\1\0)\6d\0B\3\3\2'\4\6\0B\1\3\2=\1\2\0006\0\0\0009\0\1\0004\1\0\0=\1\a\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0)\1\0\0=\1\t\0006\0\0\0009\0\1\0)\1\1\0=\1\n\0K\0\1\0\27startify_change_to_dir startify_change_to_vcs_root\27startify_enable_unsafe\27startify_custom_header\18string(v:val)\nrange\bmap\afn\28startify_custom_indices\6g\bvim\0", "config", "vim-startify")
time([[Config for vim-startify]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file WhichKey lua require("packer.load")({'which-key.nvim'}, { cmd = "WhichKey", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file MundoToggle lua require("packer.load")({'vim-mundo'}, { cmd = "MundoToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rust.vim'}, { ft = "rust" }, _G.packer_plugins)]]
vim.cmd [[au FileType nginx ++once lua require("packer.load")({'nginx.vim'}, { ft = "nginx" }, _G.packer_plugins)]]
vim.cmd [[au FileType vue ++once lua require("packer.load")({'vim-vue'}, { ft = "vue" }, _G.packer_plugins)]]
vim.cmd [[au FileType nim ++once lua require("packer.load")({'nim.vim'}, { ft = "nim" }, _G.packer_plugins)]]
vim.cmd [[au FileType svelte ++once lua require("packer.load")({'vim-svelte'}, { ft = "svelte" }, _G.packer_plugins)]]
vim.cmd [[au FileType glsl ++once lua require("packer.load")({'vim-glsl'}, { ft = "glsl" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'vim-graphql', 'vim-jsdoc', 'vim-mdx-js', 'vim-node'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescriptreact ++once lua require("packer.load")({'vim-graphql', 'vim-jsdoc', 'vim-mdx-js', 'vim-node'}, { ft = "typescriptreact" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascriptreact ++once lua require("packer.load")({'vim-graphql', 'vim-jsdoc', 'vim-mdx-js', 'vim-node'}, { ft = "javascriptreact" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'vim-graphql', 'vim-jsdoc', 'vim-mdx-js', 'vim-node'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType solidity ++once lua require("packer.load")({'vim-solidity'}, { ft = "solidity" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'vim-pico8-syntax'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType pico8 ++once lua require("packer.load")({'vim-pico8-syntax'}, { ft = "pico8" }, _G.packer_plugins)]]
vim.cmd [[au FileType graphql ++once lua require("packer.load")({'vim-graphql', 'vim-jsdoc', 'vim-mdx-js', 'vim-node'}, { ft = "graphql" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-markdown'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-matchup'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-graphql/ftdetect/graphql.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-graphql/ftdetect/graphql.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-graphql/ftdetect/graphql.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-mdx-js/ftdetect/mdx.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-mdx-js/ftdetect/mdx.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-mdx-js/ftdetect/mdx.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-node/ftdetect/node.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-node/ftdetect/node.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-node/ftdetect/node.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-pico8-syntax/ftdetect/pico8.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-pico8-syntax/ftdetect/pico8.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-pico8-syntax/ftdetect/pico8.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-solidity/ftdetect/solidity.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-solidity/ftdetect/solidity.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-solidity/ftdetect/solidity.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-svelte/ftdetect/svelte.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-svelte/ftdetect/svelte.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-svelte/ftdetect/svelte.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-vue/ftdetect/vue.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-vue/ftdetect/vue.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/vim-vue/ftdetect/vue.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/rust.vim/ftdetect/rust.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/rust.vim/ftdetect/rust.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/rust.vim/ftdetect/rust.vim]], false)
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/nim.vim/ftdetect/nim.vim]], true)
vim.cmd [[source /home/pierre/.local/share/nvim/site/pack/packer/opt/nim.vim/ftdetect/nim.vim]]
time([[Sourcing ftdetect script at: /home/pierre/.local/share/nvim/site/pack/packer/opt/nim.vim/ftdetect/nim.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
