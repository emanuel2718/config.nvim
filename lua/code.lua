local vscode = require('vscode')
local opt = vim.opt
local map = vim.keymap.set

vim.g.mapleader = " "

opt.smartcase = true
opt.inccommand = "split"


map('n', '<leader>fs', function() vscode.action('workbench.action.files.save') end)
map('n', '<leader>.', function() vscode.action('workbench.action.quickOpen') end)
map('n', '<leader>o', function() vscode.action('workbench.action.closeEditorsInGroup') end)
map('n', '<leader>m', function() vscode.action('workbench.action.splitEditor') end)
map('n', '<leader>n', function() vscode.action('workbench.action.splitEditorDown') end)
map('n', '<leader><leader>', function() vscode.action('workbench.action.showAllEditors') end)
map('n', '<leader>si', function() vscode.action('workbench.action.gotoSymbol') end)
-- map('n', '<leader>si', function() vscode.action('workbench.action.showAllSymbols') end)
map('n', '<leader>sp', function() vscode.action('workbench.action.findInFiles') end)
map('n', '<leader>d.', function() vscode.action('workbench.actions.view.problems') end)
map('n', '<leader>lf', function() vscode.action('editor.action.format') end)
map('n', '<leader>ht', function() vscode.action('workbench.action.selectTheme') end)
map('n', '<C-c>', function() vscode.action('editor.action.quickFix') end)

map('v', '>', function() vscode.action('editor.action.indentLines') end)
map('v', '<', function() vscode.action('editor.action.outdentLines') end)
map('v', 'J', function() vscode.action('editor.action.moveLinesDownAction') end)
map('v', 'K', function() vscode.action('editor.action.moveLinesUpAction') end)

-- respect system clipboard
map("v", "<leader>y", [["+y]])
map("n", "<leader>y", [["+Y]])
map("n", "<leader>`", "<cmd>e #<cr>")


