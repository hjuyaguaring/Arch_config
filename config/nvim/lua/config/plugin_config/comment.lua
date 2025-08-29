require('Comment').setup({
    pre_hook = function(ctx)
        -- Soporte para comentarios en todos los lenguajes
        local utils = require('Comment.utils')
        
        -- Detectar si es comentario de línea o bloque
        local type = ctx.ctype == utils.ctype.line and '__default' or '__multiline'
        
        -- Usar treesitter para mejor detección
        local location = nil
        if ctx.ctype == utils.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end
        
        return require('ts_context_commentstring.internal').calculate_commentstring({
            key = type,
            location = location,
        })
    end,
})
