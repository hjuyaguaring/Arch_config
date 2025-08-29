-- local lspconfig = require('lspconfig')
--
-- -- Configuración global de LSP
-- vim.diagnostic.config({
--     virtual_text = true,
--     signs = true,
--     underline = true,
--     update_in_insert = false,
-- })
--
-- -- Signs para diagnósticos
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
--
-- -- Capacidades mejoradas
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
-- -- ========== CONFIGURACIÓN DE LSPs POR LENGUAJE ==========
--
-- -- Lua
-- lspconfig.lua_ls.setup({
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = { version = 'LuaJIT' },
--             diagnostics = { globals = {'vim'} },
--             workspace = { library = vim.api.nvim_get_runtime_file("", true) },
--             telemetry = { enable = false },
--         }
--     }
-- })
--
-- -- C/C++
-- lspconfig.clangd.setup({
--     capabilities = capabilities,
--     cmd = {
--         "clangd",
--         "--background-index",
--         "--clang-tidy",
--         "--header-insertion=never",
--     },
-- })
--
-- -- Python
-- lspconfig.pyright.setup({
--     capabilities = capabilities,
--     settings = {
--         python = {
--             analysis = {
--                 autoSearchPaths = true,
--                 diagnosticMode = "workspace",
--                 useLibraryCodeForTypes = true
--             }
--         }
--     }
-- })
--
-- -- Java
-- lspconfig.jdtls.setup({
--     capabilities = capabilities,
--     -- jdtls se configura generalmente de forma diferente
--     --可能需要配置 adicional para el workspace
-- })
--
-- -- GO
-- lspconfig.gopls.setup({
--     capabilities = capabilities,
--     settings = {
--         gopls = {
--             analyses = {
--                 unusedparams = true,
--             },
--             staticcheck = true,
--         },
--     },
-- })
--
-- -- Dart/Flutter
-- lspconfig.dartls.setup({
--     capabilities = capabilities,
--     cmd = { "dart", "language-server", "--protocol=lsp" },
--     init_options = {
--         closingLabels = true,
--         flutterOutline = true,
--         onlyAnalyzeProjectsWithOpenFiles = true,
--         outline = true,
--         suggestFromUnimportedLibraries = true,
--     },
-- })
--
-- -- JavaScript/TypeScript
-- lspconfig.tsserver.setup({
--     capabilities = capabilities,
-- })
--
-- -- HTML
-- lspconfig.html.setup({
--     capabilities = capabilities,
-- })
--
-- -- CSS
-- lspconfig.cssls.setup({
--     capabilities = capabilities,
-- })
--
-- -- JSON
-- lspconfig.jsonls.setup({
--     capabilities = capabilities,
--     settings = {
--         json = {
--             schemas = require('schemastore').json.schemas(),
--             validate = { enable = true },
--         }
--     }
-- })
--
-- -- Ruby
-- lspconfig.solargraph.setup({
--     capabilities = capabilities,
-- })
--
-- -- Instalación automática de LSPs con mason-lspconfig
-- require('mason-lspconfig').setup_handlers({
--     function(server_name)
--         lspconfig[server_name].setup({
--             capabilities = capabilities,
--         })
--     end,
-- })
-- -- ========== MAPEOS PARA LSP ==========
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--     callback = function(ev)
--         local opts = { buffer = ev.buf }
--
--         -- Navegación
--         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--         vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--         vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--         vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--
--         -- Acciones
--         vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--         vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--         vim.keymap.set('n', '<leader>f', function()
--             vim.lsp.buf.format({ async = true })
--         end, opts)
--
--         -- Diagnósticos
--         vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--         vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--         vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)
--     end,
-- })
-- lsp.lua
-- Configuración flexible de LSP para Neovim

local lspconfig = require('lspconfig')
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
local schemastore_ok, schemastore = pcall(require, 'schemastore')

-- Configuración global de LSP
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

-- Signs para diagnósticos
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Capacidades mejoradas (si cmp_nvim_lsp está disponible)
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
end

-- ========== CONFIGURACIÓN DE LSPs POR LENGUAJE ==========
-- Esta sección es modular: puedes comentar/descomentar según los lenguajes que uses

-- LUA (generalmente siempre presente en Neovim)
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        }
    }
})

-- Descomenta las configuraciones según los lenguajes que uses:


-- C/C++
-- lspconfig.clangd.setup({
--     capabilities = capabilities,
--     cmd = {
--         "clangd",
--         "--background-index",
--         "--clang-tidy",
--         "--header-insertion=never",
--     },
-- })



-- Python
lspconfig.pyright.setup({
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    }
})


--[[
-- Java
lspconfig.jdtls.setup({
    capabilities = capabilities,
    -- jdtls generalmente necesita configuración adicional para el workspace
})
--]]

--[[
-- GO
lspconfig.gopls.setup({
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})
--]]

--[[
-- Rust (necesita rust-analyzer)
lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})
--]]

--[[
-- Dart/Flutter
lspconfig.dartls.setup({
    capabilities = capabilities,
    cmd = { "dart", "language-server", "--protocol=lsp" },
    init_options = {
        closingLabels = true,
        flutterOutline = true,
        onlyAnalyzeProjectsWithOpenFiles = true,
        outline = true,
        suggestFromUnimportedLibraries = true,
    },
})
--]]

--[[
-- JavaScript/TypeScript
lspconfig.tsserver.setup({
    capabilities = capabilities,
})
--]]

--[[
-- HTML
lspconfig.html.setup({
    capabilities = capabilities,
})
--]]

--[[
-- CSS
lspconfig.cssls.setup({
    capabilities = capabilities,
})
--]]

--[[
-- JSON
lspconfig.jsonls.setup({
    capabilities = capabilities,
    settings = schemastore_ok and {
        json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
        }
    } or nil
})
--]]

--[[
-- Ruby
lspconfig.solargraph.setup({
    capabilities = capabilities,
})
--]]

-- Instalación automática de LSPs con mason-lspconfig (si está disponible)
if mason_lspconfig_ok then
    mason_lspconfig.setup_handlers({
        function(server_name)
            -- Evitar configurar servidores que ya hemos configurado manualmente
            local configured_servers = {
                "lua_ls", "clangd", "pyright", "jdtls", "gopls", 
                "rust_analyzer", "dartls", "tsserver", "html", 
                "cssls", "jsonls", "solargraph"
            }
            
            local already_configured = false
            for _, server in ipairs(configured_servers) do
                if server == server_name then
                    already_configured = true
                    break
                end
            end
            
            if not already_configured then
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end
        end,
    })
end

-- ========== MAPEOS PARA LSP ==========

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }

        -- Navegación
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- Acciones
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        -- Diagnósticos
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)
    end,
})

-- Función de utilidad para agregar nuevos LSPs fácilmente
function _G.add_lsp_config(server_name, custom_config)
    local config = {
        capabilities = capabilities,
    }
    
    -- Combinar con configuración personalizada si se proporciona
    if custom_config then
        for k, v in pairs(custom_config) do
            config[k] = v
        end
    end
    
    lspconfig[server_name].setup(config)
    print("LSP configurado para: " .. server_name)
end

-- Ejemplos de uso (descomenta y modifica según necesites):
-- add_lsp_config("clangd", {cmd = {"clangd", "--background-index"}})
-- add_lsp_config("pyright")
