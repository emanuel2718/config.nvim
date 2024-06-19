---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local colorMellow = function()
  vim.cmd [[colorscheme mellow]]
end

local colorHybrid = function()
  vim.cmd [[colorscheme hybrid]]
end

local colorBlueMoon = function()
  vim.cmd [[colorscheme blue-moon]]
end

local colorRasmus = function()
  vim.cmd [[colorscheme rasmus]]
end

local colorGruberDarker = function()
  vim.cmd [[colorscheme gruber-darker]]
  vim.cmd [[highlight Normal guibg=#101010]]
end

local colorGruvbox = function()
  vim.cmd [[ colorscheme gruvbox ]]
  vim.g.gruvbox_italic = 0
  vim.g.gruvbox_bold = 1
  vim.g.gruvbox_termcolors = 256
  vim.g.gruvbox_contrast_dark = "hard"
  vim.g.gruvbox_invert_selection = 0
end

local colorGruvboxMaterial = function()
  vim.g.gruvbox_material_enable_italic = false
  vim.g.gruvbox_material_background = "hard"
  vim.cmd.colorscheme "gruvbox-material"
end

local highlight = function()
  -- blue highlight on autocompletion menu
  vim.cmd [[highlight PmenuSel guibg=blue guifg=white]]

  -- blue cursor in telescope
  vim.cmd [[highlight TelescopeSelection guibg=blue]]
end

local colorGruvboxCommunity = function()
  vim.cmd [[colorscheme gruvbox]]
  vim.cmd [[ highlight LineNr guibg=NONE ctermbg=NONE ]]
  vim.cmd [[ highlight SignColumn guibg=NONE ctermbg=NONE ]]
end

-- colorscheme
colorGruvboxCommunity()
highlight()
