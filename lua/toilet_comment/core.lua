local utils = require("toilet_comment.utils")
local config = require("toilet_comment.config")

local M = {}

M.config = vim.deepcopy(config.defaults)

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)
end

function M.generate_ascii(text, font)
  local cmd = string.format("toilet -f %s '%s'", font, vim.fn.shellescape(text))
  local handle = io.popen(cmd)
  if not handle then return nil end

  local result = handle:read("*a")
  handle:close()

  return result
end

function M.convert_selection(opts)
  opts = opts or {}
  local font = opts.font or M.config.font
  local add_space = opts.add_space_below
  if add_space == nil then add_space = M.config.add_space_below end

  local text = utils.get_visual_selection()
  if not text or text == "" then
    vim.notify("No text selected!", vim.log.levels.WARN)
    return
  end

  local ascii = M.generate_ascii(text, font)
  if not ascii then
    vim.notify("Failed to generate ASCII art. Is 'toilet' installed?", vim.log.levels.ERROR)
    return
  end

  local filetype = vim.bo.filetype
  local prefix = opts.comment_prefix or M.config.comment_prefix or utils.get_comment_prefix(filetype)

  local lines = {}
  for line in ascii:gmatch("[^\r\n]+") do
    if line:match("%S") then
      table.insert(lines, prefix .. line)
    end
  end

  if add_space then
    table.insert(lines, prefix)
  end

  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)

  vim.notify(string.format("ASCII comment created with font: %s", font), vim.log.levels.INFO)
end

function M.convert_selection_interactive()
  local fonts = utils.get_fonts()

  vim.ui.input({
    prompt = "Select toilet font: ",
    default = M.config.font,
  }, function(input)
    if input then
      M.convert_selection({ font = input })
    end
  end)
end

return M
