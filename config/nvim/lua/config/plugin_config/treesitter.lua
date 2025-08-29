require('nvim-treesitter.configs').setup({
    ensure_installed = {
        -- Lenguajes que ya tenías
        'ruby', 'lua', 'vim', 'javascript', 'typescript', 'html', 'css',
        
        -- NUEVOS LENGUAJES
        'c',           -- C
        'cpp',         -- C++
        'java',        -- Java
        'python',      -- Python
        'go',          -- GO
        'dart',        -- Dart (para Flutter)
        'json',        -- JSON
        'yaml',        -- YAML
        'markdown',    -- Markdown
        'bash',        -- Bash/Shell
        'sql',         -- SQL
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})
