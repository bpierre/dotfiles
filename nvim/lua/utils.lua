function keymap(mode, left, right, opts)
  opts = opts or {}
  return vim.api.nvim_set_keymap(mode, left, right, opts)
end

function keymap_buf(mode, left, right, opts)
  opts = opts or {}
  return vim.api.nvim_buf_set_keymap(0, mode, left, right, opts)
end
