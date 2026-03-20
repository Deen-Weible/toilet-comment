local M = {}

-- Get comment prefix based on filetype
function M.get_comment_prefix(filetype)
  local prefixes = {
    lua = "-- ",
    python = "# ",
    javascript = "// ",
    typescript = "// ",
    cpp = "// ",
    c = "// ",
    rust = "// ",
    go = "// ",
    ruby = "# ",
    bash = "# ",
    vim = '" ',
    html = "<!-- ",
    css = "/* ",
  }
  return prefixes[filetype] or "-- "
end

-- Get visual selection content
function M.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if start_pos[2] == end_pos[2] then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  return table.concat(lines, " ")
end

-- Get available toilet fonts
function M.get_fonts()
  local handle = io.popen("toilet -I 2>&1")
  if not handle then return {} end

  local fonts = {}
  for line in handle:lines() do
    for font in line:gmatch("-f%s+(%S+)") do
      table.insert(fonts, font)
    end
  end
  handle:close()

  if #fonts == 0 then
    fonts = { "standard", "big", "block", "banner", "digital", "future", "gothic", "script" }
  end

  return fonts
end

return M
