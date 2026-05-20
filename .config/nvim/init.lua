vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

vim.g.catppuccin_flavour = 'mocha' 
vim.cmd.colorscheme('catppuccin')

-- Plugins
vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }
})
