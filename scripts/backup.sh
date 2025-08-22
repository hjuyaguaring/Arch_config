#!/bin/bash

echo "=== INICIANDO RESPALDO AUTOMÁTICO ==="

# Archivo de configuración
CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"

# Cargar configuración
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Configuración por defecto
    CONFIG_DIRS=("hypr" "kitty")
    CONFIG_FILES=("")
    echo "Creando archivo de configuración por defecto"
    echo "CONFIG_DIRS=(${CONFIG_DIRS[@]})" > "$CONFIG_FILE"
    echo "CONFIG_FILES=(${CONFIG_FILES[@]})" >> "$CONFIG_FILE"
fi

# Función para respaldar directorios
backup_directories() {
    for config in "${CONFIG_DIRS[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            echo "Respaldo de directorio: $config"
            mkdir -p "$HOME/docfiles/config/$config"
            rsync -av --delete "$HOME/.config/$config/" "$HOME/docfiles/config/$config/" 2>/dev/null
            echo "$config respaldado correctamente"
        else
            echo "Directorio $config no existe, omitiendo"
        fi
    done
}

# Función para respaldar archivos individuales
backup_individual_files() {
    for config in "${CONFIG_FILES[@]}"; do
        if [ -n "$config" ] && [ -f "$HOME/.config/$config" ]; then
            echo "Respaldo de archivo: $config"
            config_dir=$(dirname "$config")
            mkdir -p "$HOME/docfiles/config/$config_dir"
            cp -v "$HOME/.config/$config" "$HOME/docfiles/config/$config"
            echo "$config respaldado correctamente"
        fi
    done
}

# Función para respaldar archivos del home
backup_home_files() {
    important_files=(".bashrc" ".zshrc" ".xprofile" ".profile")
    for file in "${important_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            echo "Respaldo de: $file"
            cp -v "$HOME/$file" "$HOME/docfiles/"
        fi
    done
}

# Función para respaldar paquetes
backup_packages() {
    echo "Respaldo de lista de paquetes..."
    pacman -Qqe > "$HOME/docfiles/packages/native-packages.txt"
    pacman -Qqm > "$HOME/docfiles/packages/aur-packages.txt"
    echo "Listas de paquetes respaldadas"
}

# Ejecutar todas las funciones de respaldo
backup_directories
backup_individual_files
backup_home_files
backup_packages

echo "Respaldo completado!"
echo "=== FIN DEL RESPALDO ==="
