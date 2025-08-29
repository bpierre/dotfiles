-- LSP configs, usually started from the nvim-lspconfig repository:
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/*

-- TypeScript
-- requires @vtsls/language-server installed globally:
-- pnpm add -g @vtsls/language-server
vim.lsp.enable("vtsls")
vim.lsp.config("vtsls", {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "package.json",
    "jsconfig.json",
    ".git",
  },
})

-- TypeScript
-- requires typescript and typescript-language-server installed globally:
-- pnpm add -g typescript typescript-language-server
-- vim.lsp.enable("ts_ls")
-- vim.lsp.config("ts_ls", {
--   filetypes = {
--     "javascript",
--     "javascriptreact",
--     "javascript.jsx",
--     "typescript",
--     "typescriptreact",
--     "typescript.tsx",
--   },
--   root_markers = {
--     "tsconfig.json",
--     "jsconfig.json",
--     ".git",
--   },
-- })

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
-- requires lua_ls: paru -S lua-language-server
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    })
  end,
  settings = { Lua = {} },
})

-- Solidity
vim.lsp.enable("solidity_ls")
vim.lsp.config("solidity_ls", {
  root_markers = {
    "hardhat.config.js",
    "hardhat.config.ts",
    "foundry.toml",
    "remappings.txt",
    "truffle.js",
    "truffle-config.js",
    "ape-config.yaml",
    ".git",
    "package.json",
  },
  settings = {
    solidity = {
      compileUsingRemoteVersion = "latest",
      defaultCompiler = "remote",
      enabledAsYouTypeCompilationErrorCheck = true,
    },
  },
})
