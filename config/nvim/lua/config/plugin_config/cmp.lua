local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)  -- Soporte para snippets
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ 
            select = true,
            behavior = cmp.ConfirmBehavior.Replace  -- Mejor comportamiento
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()  -- Comportamiento normal de Tab
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()  -- Comportamiento normal de Shift+Tab
            end
        end, {'i', 's'}),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },      -- Lenguajes de programación
        { name = 'luasnip' },       -- Snippets
        { name = 'buffer' },        -- Texto del buffer actual
        { name = 'path' },          -- Rutas de archivos
        { name = 'nvim_lua' },      -- API de Neovim
    }, {
        { name = 'buffer' },        -- Fuente secundaria
    })
})

-- Autocompletado en modo línea de comandos
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
