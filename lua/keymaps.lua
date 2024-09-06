-- lua/keymaps.lua
local M = {}

-- Function to open terminal at the bottom with height 25 lines
function M.open_terminal()
  vim.cmd("bel split") -- Create a horizontal split below
  vim.cmd("resize 9") -- Set the split height to 25 lines
  vim.cmd("terminal") -- Open the terminal
  vim.cmd('wincmd J') --move cursor to the new split
end

-- Set up keybinding to open terminal
function M.setup()
  vim.api.nvim_set_keymap(
    "n",
    "<leader>t",
    ':lua require("keymaps").open_terminal()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
end

return M
