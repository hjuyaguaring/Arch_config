#!/bin/bash

echo "=== DESCUBRIMIENTO SEMI-AUTOMÁTICO DE CONFIGURACIONES ==="

# Archivo de configuración
CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"
source "$CONFIG_FILE"

# Directorios comunes en ~/.config/
common_configs=("hypr" "kitty" "waybar" "wofi" "mako" "fish" "nvim" "ranger" 
                "gtk-3.0" "gtk-4.0" "fontconfig" "starship" "alacritty" "foot")

echo "🔍 Buscando configuraciones existentes en ~/.config/..."

new_configs=()
for config in "${common_configs[@]}"; do
    # Si existe el directorio pero NO está en la lista de backup
    if [ -d "$HOME/.config/$config" ] && [[ ! " ${CONFIG_DIRS[@]} " =~ " ${config} " ]]; then
        echo "📁 Nuevo directorio encontrado: $config"
        new_configs+=("$config")
    fi
done

if [ ${#new_configs[@]} -eq 0 ]; then
    echo "✅ No se encontraron configuraciones nuevas"
    exit 0
fi

echo ""
echo "🎯 Configuraciones descubiertas:"
for config in "${new_configs[@]}"; do
    echo "   • $config"
done

echo ""
echo "¿Quieres añadir estas configuraciones al backup? (y/N)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # Añadir a la configuración
    for config in "${new_configs[@]}"; do
        CONFIG_DIRS+=("$config")
        echo "✅ Añadido: $config"
    done
    
    # Actualizar archivo de configuración
    echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
    echo "CONFIG_FILES=()" >> "$CONFIG_FILE"
    
    echo ""
    echo "🔄 Ejecutando backup para incluir las nuevas configuraciones..."
    ~/docfiles/scripts/backup.sh
else
    echo "❌ No se añadieron nuevas configuraciones"
fi
