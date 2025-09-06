-- ~/.config/nvim/lua/config/keymaps.lua
--
-- Limpiar keymaps existentes antes de definir nuevos

local keymap = vim.keymap.set

local opts = { noremap = true, silent = true }

-- ==================== MAPEOS ESTILO ====================

-- Ir a línea específica directamente
-- :15       -- Ir a la línea 15
-- :100      -- Ir a la línea 100
-- :+5       -- Ir 5 líneas hacia adelante
-- :-3       -- Ir 3 líneas hacia atrás
-- === ARCHIVOS Y NAVEGACIÓN ===
keymap('n', '<C-s>', ':w<CR>', opts) -- Guardar: Ctrl + S
keymap('n', '<C-w>', ':q<CR>', opts) -- Cerrar: Ctrl + W

-- === TELESCOPE MAPEOS ===
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts)  -- Buscar archivos
keymap('n', '<C-o>', ':Telescope oldfiles<CR>', opts)    -- Archivos recientes
keymap('n', '<C-f>', ':Telescope live_grep<CR>', opts)   -- Buscar texto
keymap('n', '<C-g>', ':Telescope grep_string<CR>', opts) -- Buscar palabra bajo cursor


-- === NAVEGACIÓN ENTRE ARCHIVOS ===
keymap('n', '<A-S-Right>', '<cmd>BufferLineCycleNext<CR>', opts) -- Siguiente pestaña
keymap('n', '<A-S-Left>', '<cmd>BufferLineCyclePrev<CR>', opts)  -- Pestaña anterior

-- === SELECCIÓN DE TEXTO (MODO VISUAL) ===
-- Selección normal (como click + arrastrar)
keymap('n', '<S-Up>', 'v<Up>', opts)       -- Seleccionar hacia arriba: Shift + ↑
keymap('n', '<S-Down>', 'v<Down>', opts)   -- Seleccionar hacia abajo: Shift + ↓
keymap('n', '<S-Left>', 'v<Left>', opts)   -- Seleccionar izquierda: Shift + ←
keymap('n', '<S-Right>', 'v<Right>', opts) -- Seleccionar derecha: Shift + →

-- Selección por líneas (más útil)
keymap('n', '<S-K>', 'Vk', opts) -- Seleccionar línea arriba: Shift + K
keymap('n', '<S-J>', 'Vj', opts) -- Seleccionar línea abajo: Shift + J



-- === BÚSQUEDA Y REEMPLAZO ===
-- keymap('n', '<C-f>', '/', opts)                          -- Buscar: Ctrl + F
keymap('n', '<C-H>', ':%s// <Left><Left>', opts) -- Reemplazar: Ctrl + H
keymap('n', '<S-n>', 'n', opts)                  -- Siguiente resultado: F3
keymap('n', '<S-p>', 'N', opts)                  -- Anterior resultado: Shift + F3

-- === EDITING BÁSICO ===
keymap('n', '<C-z>', 'u', opts)     -- Deshacer: Ctrl + Z
keymap('n', '<C-y>', '<C-r>', opts) -- Rehacer: Ctrl + Y
keymap('n', '<C-a>', 'ggVG', opts)  -- Seleccionar todo: Ctrl + A

keymap('v', '<C-c>', '"+y', opts)
keymap('n', '<C-c>', '"+', opts)              -- Copiar: Ctrl + C
keymap('n', '<leader>q', ':bd<CR>', opts)     -- Líder + q
keymap('n', '<leader-S-w>', ':bw!<CR>', opts) -- Ctrl + Shift + w

keymap('n', '<C-c><C-c>', '"+yy', opts)       -- Copiar línea actual: Ctrl+C dos veces

-- === EDITING AVANZADO ===
keymap('n', '<C-/>', 'gcc', { remap = true }) -- Ctrl + / (línea)
keymap('v', '<C-/>', 'gc', { remap = true })  -- Ctrl + / (selección)
keymap('n', '//', 'gcc', { remap = true })    -- // (línea)
keymap('v', '//', 'gc', { remap = true })     -- // (selección)

-- === MOVER LÍNEAS ESTILO VSCODE ===
-- Alt + Flechas (como VSCode)
keymap('n', '<A-Up>', 'ddkP', opts)   -- Mover línea arriba: Alt + ↑
keymap('n', '<A-Down>', 'ddjP', opts) -- Mover línea abajo: Alt + ↓

-- Eliminar línea completa (como VSCode)
keymap('n', '<leader>d', '"_dd', opts) -- Líder + d (eliminar sin copiar)

-- === DEBUGGING (si usas nvim-dap) ===
keymap('n', '<F5>', ':lua require"dap".continue()<CR>', opts)          -- Start/Continue: F5
keymap('n', '<F9>', ':lua require"dap".toggle_breakpoint()<CR>', opts) -- Breakpoint: F9
keymap('n', '<F10>', ':lua require"dap".step_over()<CR>', opts)        -- Step Over: F10
keymap('n', '<F11>', ':lua require"dap".step_into()<CR>', opts)        -- Step Into: F11

-- === LSP Y AUTOCOMPLETADO ===
keymap('n', '<C-.>', ':lua vim.lsp.buf.code_action()<CR>', opts)     -- Quick Fix: Ctrl + .
keymap('n', '<F12>', ':lua vim.lsp.buf.definition()<CR>', opts)      -- Ir a definición: F12
keymap('n', '<C-Space>', ':lua require("cmp").complete()<CR>', opts) -- Autocomplete: Ctrl + Space



-- ==================== FUNCIONALIDADES ESPECÍFICAS ====================

-- Mapeos dentro de NvimTree
keymap('n', '<C-b>', ':NvimTreeToggle<CR>', opts) -- Toggle explorer: Ctrl + B
-- ← → ↑ ↓    - Navegación
-- o / Enter  - Abrir archivo/directorio
-- a          - Crear archivo
-- d          - Eliminar archivo
-- r          - Renombrar archivo
-- q          - Cerrar NvimTree
-- R          - Refrescar
-- ?          - Mostrar ayuda

-- Pestañas
keymap('n', 'te', ':tabedit<CR>', opts) -- Nueva pestaña

-- Divisiones de ventana
keymap('n', 'ss', ':split<Return>', opts)  -- Dividir horizontalmente
keymap('n', 'sv', ':vsplit<Return>', opts) -- Dividir verticalmente
-- Cerrar ventanas
keymap('n', 'sq', ':close<CR>', opts)      -- Cerrar ventana actual
keymap('n', 'sQ', ':q!<CR>', opts)         -- Forzar cierre ventana
-- Movimiento entre ventanas
keymap('n', 'sa', '<C-w>h', opts)          -- Mover a ventana izquierda
keymap('n', 'sw', '<C-w>k', opts)          -- Mover a ventana superior
keymap('n', 'sx', '<C-w>j', opts)          -- Mover a ventana inferior
keymap('n', 'sd', '<C-w>l', opts)          -- Mover a ventana derecha

-- ==================== VERIFICACIÓN AVANZADA DE KEYMAPS ====================

-- Comando para verificar duplicados en archivos y cargados
vim.api.nvim_create_user_command('CheckKeymaps',
  function()
    require('config.check_duplicates').check_duplicate_keymaps()
  end,
  { desc = 'Verificar keymaps duplicados en archivos y memoria' }
)

-- Comando para solo escanear archivos
vim.api.nvim_create_user_command('CheckKeymapsFiles',
  function()
    local duplicates = require('config.check_duplicates').scan_config_files()
    if #duplicates > 0 then
      print("🎯 KEYMAPS DUPLICADOS EN ARCHIVOS:")
      for _, dup in ipairs(duplicates) do
        print(string.format("  %s %s:", dup.mode, dup.lhs))
        print("    ├─ " .. dup.first_file)
        print("    └─ " .. dup.second_file)
        print("")
      end
    else
      print("✅ No se encontraron keymaps duplicados en archivos")
    end
  end,
  { desc = 'Verificar keymaps duplicados solo en archivos' }
)

-- Mapeos rápidos
keymap('n', 'ck', ':CheckKeymaps<CR>', { desc = 'Check all keymap duplicates' })
keymap('n', 'cf', ':CheckKeymapsFiles<CR>', { desc = 'Check file keymap duplicates' })


-- Diagnósticos
keymap('n', '<C-j>', function()
  vim.diagnostic.goto_next()
end, opts)

-- ==================== CONFIGURACIÓN ADICIONAL NECESARIA ====================

-- Para el modo insertar con comportamiento similar a VSCode
vim.opt.backspace = 'indent,eol,start' -- Backspace normal

-- Habilitar portapapeles del sistema
vim.opt.clipboard = 'unnamedplus'

-- Agregar al final de tu keymaps.lua

-- ==================== MARKER GROUPS (ANOTACIONES DE CÓDIGO) ====================
-- Los keymaps principales ya están configurados con <leader>k + [tecla]
-- Pero puedes agregar algunos más directos si quieres

-- Accesos rápidos adicionales (opcionales)
-- keymap('n', '<C-k><C-a>', ':MarkerAdd ', { desc = 'Quick add marker (type annotation)' })
-- keymap('n', '<C-k><C-v>', ':MarkerGroupsView<CR>', opts) -- Vista rápida
-- keymap('n', '<C-k><C-l>', ':MarkerGroupsList<CR>', opts) -- Lista rápida de grupos

-- === RESUMEN DE KEYMAPS MARKER-GROUPS ===
-- <leader>ka    - Agregar marcador (normal/visual)
-- <leader>ke    - Editar marcador en cursor
-- <leader>kd    - Eliminar marcador en cursor
-- <leader>kl    - Listar marcadores en buffer
-- <leader>ki    - Info del marcador en cursor
-- <leader>kgc   - Crear grupo
-- <leader>kgs   - Seleccionar grupo
-- <leader>kgl   - Listar grupos
-- <leader>kgr   - Renombrar grupo
-- <leader>kgd   - Eliminar grupo
-- <leader>kgi   - Info del grupo activo
-- <leader>kgb   - Crear grupo desde rama git
-- <leader>kv    - Toggle vista drawer
-- <leader>ktg   - Telescope: grupos
-- <leader>ktm   - Telescope: marcadores
