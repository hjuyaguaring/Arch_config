#!/bin/bash

echo "=== INICIANDO RESPALDO AUTOMÁTICO ==="

# Archivo de configuración
CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"

# Cargar configuración
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "📋 Configuración cargada: ${CONFIG_DIRS[@]}"
else
    echo "❌ Archivo de configuración no encontrado"
    exit 1
fi

# Función para respaldar directorios
backup_directories() {
    for config in "${CONFIG_DIRS[@]}"; do
        echo ""
        echo "🔍 Procesando: $config"
        
        if [ -d "$HOME/.config/$config" ]; then
            echo "📦 Respaldo de directorio: $config"
            echo "📍 Origen: $HOME/.config/$config/"
            echo "📍 Destino: $HOME/docfiles/config/$config/"
            
            # Crear directorio de destino si no existe
            mkdir -p "$HOME/docfiles/config/$config"
            
            # Verificar permisos
            echo "🔓 Permisos origen: $(ls -ld "$HOME/.config/$config")"
            echo "🔓 Permisos destino: $(ls -ld "$HOME/docfiles/config/$config")"
            
            # Hacer el backup con más verbosidad
            rsync -av --delete "$HOME/.config/$config/" "$HOME/docfiles/config/$config/"
            
            # Verificar resultado
            if [ $? -eq 0 ]; then
                echo "✅ $config respaldado correctamente"
                echo "📊 Archivos copiados: $(find "$HOME/docfiles/config/$config" -type f | wc -l)"
            else
                echo "❌ Error en respaldo de $config"
            fi
            
        else
            echo "⚠ Directorio $config no existe en ~/.config/, omitiendo"
        fi
    done
}

# Función para respaldar archivos del home
backup_home_files() {
    echo ""
    echo "🏠 Respaldo de archivos del home..."
    important_files=(".bashrc" ".zshrc" ".xprofile" ".profile" ".zshenv" ".zprofile")
    for file in "${important_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            cp -v "$HOME/$file" "$HOME/docfiles/"
        fi
    done
}

# Función para respaldar paquetes
backup_packages() {
    echo ""
    echo "📦 Respaldo de lista de paquetes..."
    pacman -Qqe > "$HOME/docfiles/packages/native-packages.txt"
    pacman -Qqm > "$HOME/docfiles/packages/aur-packages.txt"
    echo "✓ Listas de paquetes respaldadas"
}

# Ejecutar todas las funciones de respaldo
backup_directories
backup_home_files
backup_packages

echo ""
echo "✅ Respaldo completado!"
echo "=== FIN DEL RESPALDO ==="
