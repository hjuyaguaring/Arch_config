#!/bin/bash

echo "Iniciando instalación de configuraciones..."

# Lista de configuraciones a instalar
configs=("hypr" "kitty")

for config in "${configs[@]}"; do
    if [ -d ~/dotfiles/config/$config ]; then
        # Crear backup si ya existe
        [ -d ~/.config/$config ] && mv ~/.config/$config ~/.config/${config}.bak
        # Crear enlace simbólico
        ln -sf ~/dotfiles/config/$config ~/.config/
        echo "✓ $config instalada"
    else
        echo "⚠️ $config no existe en dotfiles, omitiendo"
    fi
done

# Restaurar otros archivos de configuración
[ -f ~/dotfiles/.bashrc ] && ln -sf ~/dotfiles/.bashrc ~/
[ -f ~/dotfiles/.zshrc ] && ln -sf ~/dotfiles/.zshrc ~/

echo "Instalación completada!"
