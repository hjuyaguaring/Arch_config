#!/bin/bash

echo "Iniciando instalacion de configuraciones..."

# Lista de configuraciones a instalar
configs=("hypr" "kitty")

for config in "${configs[@]}"; do
    if [ -d ~/docfiles/config/$config ]; then
        # Crear backup si ya existe
        if [ -d ~/.config/$config ]; then
            backup_dir="$HOME/.config/${config}.bak.$(date +%Y%m%d_%H%M%S)"
            mv ~/.config/$config "$backup_dir"
            echo " Backup de $config creado en: $backup_dir"
        fi
        # Crear enlace simbólico
        ln -sf ~/docfiles/config/$config ~/.config/
        echo " $config instalada"
    else
        echo " $config no existe en docfiles, omitiendo"
    fi
done

# Restaurar archivos de configuración del shell
[ -f ~/docfiles/.zshrc ] && ln -sf ~/docfiles/.zshrc ~/
[ -f ~/docfiles/.bashrc ] && ln -sf ~/docfiles/.bashrc ~/

echo "Instalacion completada!"
