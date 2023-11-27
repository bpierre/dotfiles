require("plugins")
require("settings")
require("mappings")
require("utils")

vim.cmd([[
  " syntax coloration
  syntax on
  " detect filetypes and load corresponding plugins
  filetype plugin on
  " detect filetypes and load corresponding indent files
  filetype indent on

  " theme (see settings.lua for opt.termguicolors and opt.background)
  colorscheme gruvbox

  " tabs style
  highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
  highlight TabLine ctermfg=Blue ctermbg=Yellow
  highlight TabLineSel ctermfg=Red ctermbg=Yellow
]])

-- filetypes
vim.filetype.add({
  filename = {
    [".prettierrc"] = "json",
    [".eslintrc"] = "json",
    [".babelrc"] = "json",
    [".swcrc"] = "json",
  },
})

-- autojump to the last edited position when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    local last_edit = vim.api.nvim_buf_get_mark(0, '"')
    if last_edit[1] > 0 and last_edit[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, last_edit) -- set line
      vim.cmd("norm! zz") -- center line
    end
  end,
})

-- close empty buffers automatically
-- vim.api.nvim_create_autocmd("User TelescopeResumePost", {
--   pattern = "*",
--   callback = function(args)
--     -- list all buffers, delete empty ones
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--       if is_buffer_empty(buf) then
--         vim.api.nvim_buf_delete(buf, { force = true })
--       end
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("TabLeave", {
--   pattern = "*",
--   callback = function(args)
--     nvim_buf_line_count(1)
--     local bytes = vim.fn.wordcount().bytes
--     if bytes == 0 and #vim.api.nvim_buf_get_name(0) == 0 then
--       vim.api.nvim_buf_delete(args.buf, { force = true })
--     end
--   end,
-- })

-- -- refresh gitgutter on save
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*",
--   callback = function()
--     vim.cmd("GitGutter")
--   end,
-- })
