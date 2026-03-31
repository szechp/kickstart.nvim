local function yaml_percent()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local ok, parser = pcall(vim.treesitter.get_parser, 0, 'yaml')
  if not ok or not parser then vim.cmd.normal { '%', bang = true }; return end
  local tree = parser:parse()[1]
  if not tree then vim.cmd.normal { '%', bang = true }; return end

  local line_text = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ''
  local col = (line_text:find '%S' or 1) - 1
  local node = tree:root():named_descendant_for_range(row, col, row, col)

  local function node_end_row(n)
    local _, _, er, ec = n:range()
    if ec == 0 and er > 0 then er = er - 1 end
    return er
  end

  local function jump_to(target_row)
    local lines = vim.api.nvim_buf_get_lines(0, target_row, target_row + 1, false)
    local c = lines[1] and ((lines[1]:find '%S' or 1) - 1) or 0
    vim.api.nvim_win_set_cursor(0, { target_row + 1, c })
  end

  -- On a key line: jump to the end of that block
  local n = node
  while n do
    if n:type() == 'block_mapping_pair' then
      local key = n:named_child(0)
      if key and key:range() == row then
        local er = node_end_row(n)
        if er > row then jump_to(er); return end
      end
    end
    n = n:parent()
  end

  -- Not on a key line: find the outermost pair ending on this row -> jump to its key
  local target_pair = nil
  n = node
  while n do
    if n:type() == 'block_mapping_pair' and node_end_row(n) == row then target_pair = n end
    n = n:parent()
  end

  if target_pair then
    local key = target_pair:named_child(0)
    if key then jump_to(key:range()); return end
  end

  -- Sequence items or middle of block: jump to nearest enclosing key
  n = node
  while n do
    if n:type() == 'block_mapping_pair' then
      local key = n:named_child(0)
      if key and key:range() ~= row then jump_to(key:range()); return end
    end
    n = n:parent()
  end

  vim.cmd.normal { '%', bang = true }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'yaml' },
  callback = function(event)
    vim.keymap.set({ 'n', 'x' }, '%', yaml_percent, { buffer = event.buf })
  end,
})
