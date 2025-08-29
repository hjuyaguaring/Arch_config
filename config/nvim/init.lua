-- ~/.config/nvim/init.lua
-- Cargar lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Configuración básica de Neovim
require('config.options')

-- Mapeos de teclado
require('config.keymaps')

-- Autocomandos
--require('config.autocmds')

-- Configurar plugins con lazy.nvim
require('config.plugins')

require('config.keymaps') -- Esto cargará los comandos de verificación

-- Configuración de nvim-tree (mejor ponerla en plugin_config/nvim-tree.lua)
