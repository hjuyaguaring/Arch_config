require("nvim-tree").setup({
  view = {
    width = 20,
    side = "left",
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
  },
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true, -- Cerrar tree al abrir un archivo
      -- window_picker = {
      --   enable = false,     -- Deshabilitar selección de ventana
      -- },
    },
  },
})
-- -- Forzar cierre con autocmd
-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = '*',
--   callback = function()
--     if vim.bo.filetype == 'NvimTree' and #vim.api.nvim_list_wins() > 1 then
--       local current_win = vim.api.nvim_get_current_win()
--       local tree_win = nil
--
--       for _, win in ipairs(vim.api.nvim_list_wins()) do
--         local buf = vim.api.nvim_win_get_buf(win)
--         if vim.api.nvim_buf_get_name(buf):match('NvimTree') then
--           tree_win = win
--           break
--         end
--       end
--
--       if tree_win and current_win ~= tree_win then
--         vim.api.nvim_win_close(tree_win, true)
--       end
--     end
--   end
-- })
require("nvim-tree").setup({
  view = {
    width = 20,
    side = "left",
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
  },
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true, -- Cerrar tree al abrir un archivo
    },
  },
})

-- Configuración del autocmd mejorada
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Cerrar NvimTree automáticamente cuando no está enfocado',
  callback = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*',
      callback = function()
        -- Solo procesar si hay más de una ventana
        if #vim.api.nvim_list_wins() <= 1 then
          return
        end

        local current_win = vim.api.nvim_get_current_win()

        -- Buscar ventana de NvimTree
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_option(buf, 'filetype') == 'NvimTree' then
            -- Si encontramos NvimTree y no es la ventana actual, cerrarla
            if win ~= current_win then
              vim.api.nvim_win_close(win, true)
            end
            break
          end
        end
      end
    })
  end
})
