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
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
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
            local icon = level:match("error") and " " or " "
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
      -- Cargar configuración desde archivo separado
      require('config.plugin_config.nvim-tree')
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
    'williamboman/mason.nvim', -- Gestor de LSPs, linters, formatters
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
          'lua_ls',  -- Lua
          'pyright', -- Python (descomentado)
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
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
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

  -- === MARKER GROUPS (CODE ANNOTATION) ===
  {
    'jameswolensky/marker-groups.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',         -- Required
      'nvim-telescope/telescope.nvim', -- Already have it
    },
    config = function()
      require('marker-groups').setup({
        -- Usar un prefijo diferente para evitar conflictos
        keymaps = {
          enabled = true,
          prefix = "<leader>k", -- Cambié de <leader>m a <leader>k para evitar conflictos
          mappings = {
            marker = {
              add = { suffix = "a", mode = { "n", "v" }, desc = "Add marker" },
              edit = { suffix = "e", desc = "Edit marker at cursor" },
              delete = { suffix = "d", desc = "Delete marker at cursor" },
              list = { suffix = "l", desc = "List markers in buffer" },
              info = { suffix = "i", desc = "Show marker at cursor" },
            },
            group = {
              create = { suffix = "gc", desc = "Create marker group" },
              select = { suffix = "gs", desc = "Select marker group" },
              list = { suffix = "gl", desc = "List marker groups" },
              rename = { suffix = "gr", desc = "Rename marker group" },
              delete = { suffix = "gd", desc = "Delete marker group" },
              info = { suffix = "gi", desc = "Show active group info" },
              from_branch = { suffix = "gb", desc = "Create group from git branch" },
            },
            view = {
              toggle = { suffix = "v", desc = "Toggle drawer marker viewer" },
            },
            telescope = {
              groups = { suffix = "tg", desc = "Telescope: marker groups" },
              markers = { suffix = "tm", desc = "Telescope: markers in active group" },
            },
          },
        },

        -- Configuración del drawer para que no interfiera con nvim-tree
        drawer_config = {
          width = 50,     -- Un poco más pequeño
          side = "right", -- Lado derecho para no chocar con nvim-tree (izquierda)
          border = "rounded",
          title_pos = "center",
        },

        -- Configuración visual
        context_lines = 2,
        max_annotation_display = 40, -- Un poco menos para no saturar

        -- Logging
        debug = false,
        log_level = "warn", -- Solo warnings y errores para no saturar
      })
    end,
  },
})
