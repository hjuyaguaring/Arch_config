-- ~/.config/nvim/lua/config/options.lua
local opt = vim.opt
local g = vim.g

-- Opciones de interfaz
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.termguicolors = true

-- Forzar modo oscuro (CORRECTO)
opt.background = 'dark'

-- Opciones de indentación
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Opciones de búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Opciones de comportamiento
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.swapfile = false
opt.undofile = true

-- Mejor visualización de búsquedas
opt.hlsearch = true    -- Resaltar todos los resultados
opt.incsearch = true   -- Mostrar resultados mientras escribes

-- Colores para resaltado
vim.cmd('highlight Search ctermbg=Yellow ctermfg=Black guibg=#FFD700 guifg=#000000')
vim.cmd('highlight IncSearch ctermbg=Red ctermfg=White guibg=#FF0000 guifg=#FFFFFF')

-- Variables globales
g.mapleader = ' ' -- Espacio como tecla Leader
g.maplocalleader = ',' -- Leader local coma
