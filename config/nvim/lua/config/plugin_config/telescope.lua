local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            preview_width = 0.6,    -- Ancho del preview
            width = 0.9,            -- Ancho total
            height = 0.8,           -- Alto total
          },
        },
        path_display = {
          "truncate",              -- Truncar rutas largas inteligentemente
         -- "absolute",           -- O mostrar rutas absolutas completas
        },
        sorting_strategy = "ascending",
        wrap_results = true,       -- Envolver texto largo
        mappings = {
            i = {
                ['<S-Tab>'] = actions.move_selection_previous,
                ['<Tab>'] = actions.move_selection_next,
                -- ['<C-q>'] = actions.send_selected_to_qflist,
                ['<Esc>'] = actions.close,
            },
        },
        -- file_ignore_patterns = {
            -- "node_modules", ".git", "vendor", "build", "dist", "yarn.lock"
        -- },
    },
    pickers = {
        find_files = {
            theme = "dropdown",
            hidden = true,
        },
        live_grep = {
            theme = "dropdown",
        },
        buffers = {
            theme = "dropdown",
        },
    },
})

-- Cargar extensiones (opcional)
-- telescope.load_extension('fzf')
