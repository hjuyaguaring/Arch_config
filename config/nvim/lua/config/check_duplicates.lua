-- ~/.config/nvim/lua/config/check_duplicates.lua
local M = {}

-- Función para escanear archivos Lua en busca de keymaps
function M.scan_config_files()
    local config_path = vim.fn.stdpath('config') .. '/lua'
    local keymaps_found = {}
    local duplicates = {}
    
    -- Función recursiva para escanear directorios
    local function scan_directory(directory)
        local files = vim.fn.glob(directory .. '/*', true, true)
        
        for _, file in ipairs(files) do
            if vim.fn.isdirectory(file) == 1 then
                scan_directory(file)  -- Escanear subdirectorios
            elseif file:match('%.lua$') then
                M.scan_file_for_keymaps(file, keymaps_found, duplicates)
            end
        end
    end
    
    scan_directory(config_path)
    return duplicates
end

-- Escanear un archivo específico en busca de keymaps
function M.scan_file_for_keymaps(file_path, keymaps_found, duplicates)
    local content = {}
    local success, lines = pcall(function()
        return vim.fn.readfile(file_path)
    end)
    
    if not success then return end
    
    for line_num, line in ipairs(lines) do
        -- Patrones comunes de keymaps
        local patterns = {
            -- keymap%(.-['"](.-)['"].-['"](.-)['"]
            ["keymap%([^)]*['\"]([^'\"]+)['\"][^)]*['\"]([^'\"]+)['\"]"] = true,
            ["vim%.keymap%.set%([^)]*['\"]([^'\"]+)['\"][^)]*['\"]([^'\"]+)['\"]"] = true,
            ["vim%.api%.nvim_set_keymap%([^)]*['\"]([^'\"]+)['\"][^)]*['\"]([^'\"]+)['\"]"] = true,
        }
        
        for pattern in pairs(patterns) do
            local mode, lhs = line:match(pattern)
            if mode and lhs then
                local key = mode .. lhs
                local location = file_path .. ':' .. line_num
                
                if keymaps_found[key] then
                    table.insert(duplicates, {
                        key = key,
                        mode = mode,
                        lhs = lhs,
                        first_file = keymaps_found[key],
                        second_file = location
                    })
                else
                    keymaps_found[key] = location
                end
            end
        end
    end
end

-- Función principal para verificar duplicados
function M.check_duplicate_keymaps()
    print("🔍 Escaneando archivos de configuración...")
    
    -- 1. Escanear archivos de configuración
    local file_duplicates = M.scan_config_files()
    
    -- 2. Verificar keymaps ya cargados
    local loaded_duplicates = M.check_loaded_keymaps()
    
    -- Mostrar resultados
    if #file_duplicates > 0 then
        print("🎯 KEYMAPS DUPLICADOS EN ARCHIVOS:")
        for _, dup in ipairs(file_duplicates) do
            print(string.format("  %s %s:", dup.mode, dup.lhs))
            print("    ├─ " .. dup.first_file)
            print("    └─ " .. dup.second_file)
            print("")
        end
    end
    
    if #loaded_duplicates > 0 then
        print("🎯 KEYMAPS DUPLICADOS CARGADOS:")
        for _, dup in ipairs(loaded_duplicates) do
            local buf_info = dup.buffer and "(buffer-local)" or "(global)"
            print(string.format("  %s %s %s:", dup.mode, dup.lhs, buf_info))
            print("    ├─ " .. dup.first)
            print("    └─ " .. dup.second)
            print("")
        end
    end
    
    if #file_duplicates == 0 and #loaded_duplicates == 0 then
        print("✅ No se encontraron keymaps duplicados")
    end
end

-- Función para verificar keymaps ya cargados (la anterior)
function M.check_loaded_keymaps()
    local modes = {'n', 'i', 'v', 'x', 't'}
    local duplicates = {}
    
    for _, mode in ipairs(modes) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        local keymap_table = {}
        
        for _, map in ipairs(keymaps) do
            local key = mode .. map.lhs
            if keymap_table[key] then
                table.insert(duplicates, {
                    mode = mode,
                    lhs = map.lhs,
                    first = keymap_table[key].desc or keymap_table[key].rhs,
                    second = map.desc or map.rhs,
                    buffer = map.buffer ~= 0
                })
            else
                keymap_table[key] = map
            end
        end
    end
    
    return duplicates
end

return M
