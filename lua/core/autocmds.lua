local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = "200",
    }
  end,
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-- close with `q`
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {"help", "lspinfo", "man", "fugitive", "checkhealth", "oil"},
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
