-- create the directories to the current file
function create_dirs_to_current_file()
  local curdir = vim.fn.expand('%:p:h')
  vim.fn.system('mkdir -p "' .. curdir .. '"')
  print('created directory: ' .. curdir)
end

-- prompt for a command to run in a tmux pane
function open_vimux_prompt(orientation, size)
  vim.g.VimuxOrientation = orientation
  vim.g.VimuxHeight = size
  vim.fn.VimuxPromptCommand('make ')
end

-- returns the parent git directories, or '.'
-- function! FindGitDirOrCurrent()
--   let curdir = expand('%:p:h')
--   let gitdir = finddir('.git', curdir . ';')
--   if gitdir != ''
--     return substitute(gitdir, '\/\.git$', '', '')
--   else
--     return '.'
--   endif
-- endfunction
