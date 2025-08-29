-- -- ~/.config/nvim/lua/config/plugins.lua
-- return require('lazy').setup({
--
--   {
--    'akinsho/bufferline.nvim',
--     dependencies = 'nvim-tree/nvim-web-devicons',
--     config = function()
--       require('bufferline').setup({
--         options = {
--           mode = "buffers",
--           numbers = "none",
--           close_command = "bdelete! %d",
--           diagnostics = "nvim_lsp",
--           offsets = {
--             {
--               filetype = "NvimTree",
--               text = "File Explorer",
--               highlight = "Directory",
--               text_align = "left"
--             }
--           },
--         }
--       })
--     end,
--   },
--   -- === TELESCOPE (BUSCADOR) ===
--     {
--         'nvim-telescope/telescope.nvim',
--         tag = '0.1.6',
--         dependencies = {
--             'nvim-lua/plenary.nvim',
--             'nvim-tree/nvim-web-devicons'
--         },
--         config = function()
--             require('telescope').setup({
--                 defaults = {
--                     mappings = {
--                         i = {
--                             ['<C-k>'] = require('telescope.actions').move_selection_previous,
--                             ['<C-j>'] = require('telescope.actions').move_selection_next,
--                             ['<C-q>'] = require('telescope.actions').send_selected_to_qflist,
--                         },
--                     },
--                     file_ignore_patterns = {
--                         "node_modules", ".git", "vendor", "build", "dist"
--                     },
--                 },
--             })
--         end,
--     },
--     -- === TEMA ===
--     {
--         'navarasu/onedark.nvim',
--         config = function()
--             require('onedark').setup({
--                 style = 'dark',
--                 transparent = false,
--                 term_colors = true,
--             })
--             require('onedark').load()
--         end,
--         lazy = false,
--         priority = 1000,
--     },
--
--     -- === BARRA DE ESTADO ===
--     {
--         'nvim-lualine/lualine.nvim',
--         dependencies = { 'nvim-tree/nvim-web-devicons' },
--         config = function()
--             require('lualine').setup({
--                 options = {
--                     theme = 'onedark',
--                     component_separators = { left = '│', right = '│' },
--                     section_separators = { left = '', right = '' },
--                 },
--                 sections = {
--                     lualine_a = {'mode'},
--                     lualine_b = {'branch', 'diff', 'diagnostics'},
--                     lualine_c = {'filename'},
--                     lualine_x = {'encoding', 'fileformat', 'filetype'},
--                     lualine_y = {'progress'},
--                     lualine_z = {'location'}
--                 },
--             })
--         end,
--     },
--
--     -- === BUFFERLINE (PESTAÑAS) ===
--     {
--         'akinsho/bufferline.nvim',
--         dependencies = 'nvim-tree/nvim-web-devicons',
--         config = function()
--             require('bufferline').setup({
--                 options = {
--                     mode = "buffers",
--                     numbers = "none",
--                     close_command = "bdelete! %d",
--                     diagnostics = "nvim_lsp",
--                     diagnostics_indicator = function(count, level)
--                         local icon = level:match("error") and " " or " "
--                         return " " .. icon .. count
--                     end,
--                     offsets = {
--                         {
--                             filetype = "NvimTree",
--                             text = "File Explorer",
--                             highlight = "Directory",
--                             text_align = "left"
--                         }
--                     },
--                 }
--             })
--         end,
--     },
--
--     -- === EXPLORADOR DE ARCHIVOS ===
--     {
--         'nvim-tree/nvim-tree.lua',
--         dependencies = 'nvim-tree/nvim-web-devicons',
--         config = function()
--             require('nvim-tree').setup({
--                 view = {
--                     width = 30,
--                 },
--                 renderer = {
--                     icons = {
--                         glyphs = {
--                             default = "",
--                             symlink = "",
--                             folder = {
--                                 arrow_closed = "",
--                                 arrow_open = "",
--                                 default = "",
--                                 open = "",
--                                 empty = "",
--                                 empty_open = "",
--                                 symlink = "",
--                                 symlink_open = "",
--                             },
--                         },
--                     },
--                 },
--             })
--         end,
--     }, 
--
--     -- === TREESITTER (SYNTAX HIGHLIGHTING MEJORADO) ===
--     {
--         'nvim-treesitter/nvim-treesitter',
--         build = ':TSUpdate',
--         config = function()
--             require('nvim-treesitter.configs').setup({
--                 ensure_installed = { 'ruby', 'lua', 'vim', 'javascript', 'typescript', 'html', 'css' },
--                 highlight = {
--                     enable = true,
--                 },
--                 indent = {
--                     enable = true,
--                 },
--             })
--         end,
--     },
--
--     -- === ICONOS ===
--     {
--         'nvim-tree/nvim-web-devicons',
--         lazy = true,
--     },
--
--     -- === LSP CONFIG ===
--     {
--         'neovim/nvim-lspconfig',
--         config = function()
--             -- Configuración básica de LSP
--             local lspconfig = require('lspconfig')
--             local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
--             -- Configurar LSP para Ruby
--             lspconfig.solargraph.setup({
--                 capabilities = capabilities,
--             })
--
--             -- Configurar LSP para otros lenguajes
--             lspconfig.lua_ls.setup({
--                 capabilities = capabilities,
--             })
--         end,
--     },
--
--     -- === AUTOCOMPLETADO ===
--     {
--         'hrsh7th/nvim-cmp',
--         dependencies = {
--             'hrsh7th/cmp-nvim-lsp',
--             'hrsh7th/cmp-buffer',
--             'hrsh7th/cmp-path',
--             'hrsh7th/cmp-cmdline',
--         },
--         config = function()
--             local cmp = require('cmp')
--             cmp.setup({
--                 mapping = cmp.mapping.preset.insert({
--                     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--                     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--                     ['<C-Space>'] = cmp.mapping.complete(),
--                     ['<C-e>'] = cmp.mapping.abort(),
--                     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--                 }),
--                 sources = cmp.config.sources({
--                     { name = 'nvim_lsp' },
--                     { name = 'buffer' },
--                     { name = 'path' },
--                 })
--             })
--         end,
--     },
--    -- === LENGUAJES ADICIONALES ===
--     {
--         'mfussenegger/nvim-jdtls',  -- Para Java (necesario además de jdtls)
--         ft = 'java',  -- Solo carga para archivos Java
--     },
--
--     {
--         'dart-lang/dart-vim-plugin',  -- Soporte básico para Dart
--         ft = 'dart',  -- Solo carga para archivos Dart
--     },
--
--     {
--         'iamcco/coc-flutter',  -- Opcional: mejor soporte para Flutter
--         ft = 'dart',
--         run = ':CocInstall coc-flutter'
--     },
--
--     {
--         'b0o/schemastore.nvim',  -- Para JSON schemas
--         config = function()
--             -- Se usa automáticamente por jsonls
--         end,
--     },
--
--     -- === HERRAMIENTAS ADICIONALES ===
--     {
--         'williamboman/mason.nvim',  -- Gestor de LSPs, linters, formatters
--         config = function()
--             require('mason').setup()
--         end,
--     },
--     {
--     'williamboman/mason-lspconfig.nvim',
--     dependencies = 'williamboman/mason.nvim',
--     config = function()
--         require('mason-lspconfig').setup({
--             ensure_installed = {
--                 -- Nombres CORRECTOS de LSP (los que usa lspconfig)
--                 'lua_ls',       -- Lua (nota: es lua_ls, no luals)
--                 'clangd',       -- C/C++
-- --                'pyright',      -- Python
--                 'jdtls',        -- Java
-- --                'gopls',        -- GO
-- --                'dartls',       -- Dart/Flutter (CORRECTO)
-- --                'tsserver',     -- TypeScript/JavaScript (CORRECTO)
-- --                'html',         -- HTML
-- --                'cssls',        -- CSS
-- --                'jsonls',       -- JSON
-- --                'solargraph',   -- Ruby
--
--                 -- Puedes agregar más LSPs aquí
-- --                'bashls',       -- Bash
-- --                'yamlls',       -- YAML
--                 'rust_analyzer',-- Rust
--             }
--         })
--     end,
-- },
--   -- === TELESCOPE (BUSCADOR FUZZY) ===
-- {
--     'nvim-telescope/telescope.nvim',
--     tag = '0.1.6',
--     dependencies = {
--         'nvim-lua/plenary.nvim',
--         'nvim-tree/nvim-web-devicons'
--     },
--     config = function()
--         require('telescope').setup({
--             defaults = {
--                 mappings = {
--                     i = {
--                         ['<C-k>'] = require('telescope.actions').move_selection_previous,
--                         ['<C-j>'] = require('telescope.actions').move_selection_next,
--                         ['<C-q>'] = require('telescope.actions').send_selected_to_qflist,
--                     },
--                 },
--             },
--         })
--     end,
-- },
--
--
-- })
--
-- ~/.config/nvim/lua/config/plugins.lua
return require('lazy').setup({
  -- === TEMA ===
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({
        style = 'dark',
        transparent = false,
        term_colors = true,
      })
      require('onedark').load()
    end,
    lazy = false,
    priority = 1000,
  },

  -- === ICONOS ===
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },

  -- === BARRA DE ESTADO ===
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'onedark',
          component_separators = { left = '│', right = '│' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- === BUFFERLINE (PESTAÑAS) ===
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left"
            }
          },
        }
      })
    end,
  },

  -- === EXPLORADOR DE ARCHIVOS ===
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup({
        view = {
          width = 30,
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
      })
    end,
  }, 

  -- === TREESITTER (SYNTAX HIGHLIGHTING MEJORADO) ===
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua', 'vim', 'vimdoc',
          'python', -- Agregado Python
          -- 'javascript', 'typescript', 'html', 'css', 'ruby' -- Comentados por ahora
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- === TELESCOPE (BUSCADOR FUZZY) ===
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              -- ['<C-q>'] = require('telescope.actions').send_selected_to_qflist,
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git", "vendor", "build", "dist"
          },
        },
      })
    end,
  },

  -- === HERRAMIENTAS ADICIONALES ===
  {
    'williamboman/mason.nvim',  -- Gestor de LSPs, linters, formatters
    config = function()
      require('mason').setup()
    end,
  },
  
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'williamboman/mason.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',       -- Lua
          'pyright',      -- Python (descomentado)
          -- 'clangd',     -- C/C++
          -- 'jdtls',      -- Java
          -- 'gopls',      -- GO
          -- 'dartls',     -- Dart/Flutter
          -- 'tsserver',   -- TypeScript/JavaScript
          -- 'html',       -- HTML
          -- 'cssls',      -- CSS
          -- 'jsonls',     -- JSON
          -- 'solargraph', -- Ruby
          -- 'rust_analyzer',-- Rust
        }
      })
    end,
  },

  -- === LSP CONFIG ===
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      -- 'hrsh7th/cmp-nvim-lsp',
    },
    -- config = function()
    --   -- Cargar configuración desde archivo separado
    --   require('config.lsp')
    -- end,
  },

  -- === AUTOCOMPLETADO ===
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip', -- Agregar snippets
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, {'i', 's'}),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },

  -- === SNIPPETS ===
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  -- === LENGUAJES ADICIONALES (COMENTADOS) ===
  --{
  --  'mfussenegger/nvim-jdtls',  -- Para Java
  --  ft = 'java',
  --},
  --
  --{
  --  'dart-lang/dart-vim-plugin',  -- Soporte básico para Dart
  --  ft = 'dart',
  --},
  --
  --{
  --  'b0o/schemastore.nvim',  -- Para JSON schemas
  --},

  -- === FORMATTING ===
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black', 'isort' },
          -- javascript = { 'prettier' },
          -- typescript = { 'prettier' },
          -- html = { 'prettier' },
          -- css = { 'prettier' },
          -- json = { 'jq' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
})
