local opt = vim.opt

opt.undofile = true
opt.swapfile = true
opt.writebackup = false
opt.expandtab = true
opt.autoindent = true
opt.inccommand = "split"
opt.number = true
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.tabstop = 2
opt.hlsearch = true
opt.softtabstop = 2
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣"
}