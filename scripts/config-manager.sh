#!/bin/bash

CONFIG_FILE="$HOME/dotfiles/scripts/backup-config.conf"

show_help() {
    echo "Uso: $0 [add|remove|list|edit] [tipo] [nombre]"
    echo "  add [dir|file] [nombre]    - Añadir directorio o archivo"
    echo "  remove [dir|file] [nombre] - Remover directorio o archivo"
    echo "  list                       - Mostrar configuración actual"
    echo "  edit                       - Editar manualmente el archivo de configuración"
}

add_config() {
    type=$1
    name=$2
    
    if [ -z "$name" ]; then
        echo "Error: Debes especificar un nombre"
        exit 1
    fi
    
    source "$CONFIG_FILE"
    
    if [ "$type" = "dir" ]; then
        if [[ " ${CONFIG_DIRS[@]} " =~ " ${name} " ]]; then
            echo "El directorio $name ya está en la lista"
        else
            CONFIG_DIRS+=("$name")
            echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
            echo "CONFIG_FILES=(${CONFIG_FILES[@]})" >> "$CONFIG_FILE"
            echo "✅ Directorio $name añadido"
        fi
    elif [ "$type" = "file" ]; then
        if [[ " ${CONFIG_FILES[@]} " =~ " ${name} " ]]; then
            echo "El archivo $name ya está en la lista"
        else
            CONFIG_FILES+=("$name")
            echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
            echo "CONFIG_FILES=(${CONFIG_FILES[@]})" >> "$CONFIG_FILE"
            echo "✅ Archivo $name añadido"
        fi
    fi
}

remove_config() {
    type=$1
    name=$2
    
    source "$CONFIG_FILE"
    
    if [ "$type" = "dir" ]; then
        new_dirs=()
        for dir in "${CONFIG_DIRS[@]}"; do
            if [ "$dir" != "$name" ]; then
                new_dirs+=("$dir")
            fi
        done
        CONFIG_DIRS=("${new_dirs[@]}")
        echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
        echo "CONFIG_FILES=(${CONFIG_FILES[@]})" >> "$CONFIG_FILE"
        echo "✅ Directorio $name removido"
    elif [ "$type" = "file" ]; then
        new_files=()
        for file in "${CONFIG_FILES[@]}"; do
            if [ "$file" != "$name" ]; then
                new_files+=("$file")
            fi
        done
        CONFIG_FILES=("${new_files[@]}")
        echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
        echo "CONFIG_FILES=(${CONFIG_FILES[@]})" >> "$CONFIG_FILE"
        echo "✅ Archivo $name removido"
    fi
}

list_config() {
    source "$CONFIG_FILE"
    echo "📁 Directorios monitoreados:"
    for dir in "${CONFIG_DIRS[@]}"; do
        echo "  • $dir"
    done
    echo ""
    echo "📄 Archivos individuales monitoreados:"
    for file in "${CONFIG_FILES[@]}"; do
        if [ -n "$file" ]; then
            echo "  • $file"
        fi
    done
}

case "$1" in
    add)
        add_config "$2" "$3"
        ;;
    remove)
        remove_config "$2" "$3"
        ;;
    list)
        list_config
        ;;
    edit)
        nano "$CONFIG_FILE"
        ;;
    *)
        show_help
        ;;
esac
