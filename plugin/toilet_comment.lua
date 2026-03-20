-- This file is loaded at Neovim startup
-- Commands are available immediately, but functionality loads on demand

if vim.g.toilet_comment_loaded then
  return
end
vim.g.toilet_comment_loaded = true

local core = require("toilet_comment.core")

-- Create user commands
vim.api.nvim_create_user_command("ToiletComment", function()
  core.convert_selection()
end, { range = true, nargs = 0 })

vim.api.nvim_create_user_command("ToiletCommentFont", function(opts)
  core.convert_selection({ font = opts.args })
end, {
  range = true,
  nargs = 1,
  complete = function()
    local utils = require("toilet_comment.utils")
    return utils.get_fonts()
  end
})

vim.api.nvim_create_user_command("ToiletCommentInteractive", function()
  core.convert_selection_interactive()
end, { range = true, nargs = 0 })
