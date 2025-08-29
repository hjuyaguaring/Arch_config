#!/bin/bash

CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"

show_help() {
    echo "Uso: $0 [add|remove|list|edit] [nombre]"
    echo "  add [nombre]    - Añadir directorio"
    echo "  remove [nombre] - Remover directorio"
    echo "  list            - Mostrar configuración actual"
    echo "  edit            - Editar manualmente el archivo de configuración"
}

add_config() {
    name=$1
    
    if [ -z "$name" ]; then
        echo "Error: Debes especificar un nombre"
        exit 1
    fi
    
    source "$CONFIG_FILE"
    
    if [[ " ${CONFIG_DIRS[@]} " =~ " ${name} " ]]; then
        echo "El directorio $name ya está en la lista"
    else
        CONFIG_DIRS+=("$name")
        echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
        echo "CONFIG_FILES=()" >> "$CONFIG_FILE"
        echo "✅ Directorio $name añadido"
    fi
}

remove_config() {
    name=$1
    
    source "$CONFIG_FILE"
    
    new_dirs=()
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ "$dir" != "$name" ]; then
            new_dirs+=("$dir")
        fi
    done
    CONFIG_DIRS=("${new_dirs[@]}")
    echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
    echo "CONFIG_FILES=()" >> "$CONFIG_FILE"
    echo "✅ Directorio $name removido"
}

list_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "❌ Archivo de configuración no encontrado: $CONFIG_FILE"
        echo "💡 Ejecuta primero: ~/docfiles/scripts/backup.sh"
        exit 1
    fi
    
    source "$CONFIG_FILE"
    echo "📁 Directorios en lista de backup:"
    echo ""
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ -d "$HOME/.config/$dir" ]; then
            echo "  • $dir ✅ (existe en sistema)"
        elif [ -d "$HOME/docfiles/config/$dir" ]; then
            echo "  • $dir 📦 (solo en backup)"
        else
            echo "  • $dir ❌ (no existe en ningún lado)"
        fi
    done
}

case "$1" in
    add)
        add_config "$2"
        ;;
    remove)
        remove_config "$2"
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
