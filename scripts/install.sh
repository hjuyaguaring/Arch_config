#!/bin/bash

echo "Iniciando instalación de configuraciones..."

# Archivo de configuración
CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"
source "$CONFIG_FILE"

for config in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/docfiles/config/$config" ]; then
        # Crear backup si ya existe
        if [ -d "$HOME/.config/$config" ]; then
            backup_dir="$HOME/.config/${config}.bak.$(date +%Y%m%d_%H%M%S)"
            mv ~/.config/$config "$backup_dir"
            echo "✓ Backup de $config creado en: $backup_dir"
        fi
        # Crear enlace simbólico
        ln -sf ~/docfiles/config/$config ~/.config/
        echo "✓ $config instalada"
    else
        echo "⚠ $config no existe en docfiles, omitiendo"
    fi
done

# Restaurar archivos de configuración del shell
[ -f ~/docfiles/.zshrc ] && ln -sf ~/docfiles/.zshrc ~/
[ -f ~/docfiles/.bashrc ] && ln -sf ~/docfiles/.bashrc ~/

echo "Instalación completada!"
