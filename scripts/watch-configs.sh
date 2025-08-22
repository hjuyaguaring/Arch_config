#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== MONITOR DE CONFIGURACIONES INICIADO ===${NC}"
echo -e "${YELLOW}Monitoreando cambios en configuraciones...${NC}"
echo -e "${YELLOW}Presiona Ctrl+C para detener${NC}"

# Archivo de configuración
CONFIG_FILE="$HOME/docfiles/scripts/backup-config.conf"
source "$CONFIG_FILE"

# Directorios a monitorear
WATCH_DIRS=()
for dir in "${CONFIG_DIRS[@]}"; do
    WATCH_DIRS+=("$HOME/.config/$dir")
done

for file in "${CONFIG_FILES[@]}"; do
    if [ -n "$file" ]; then
        WATCH_DIRS+=("$HOME/.config/$file")
    fi
done

# Archivos importantes del home
HOME_FILES=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.xprofile" "$HOME/.profile")

# Función para ejecutar backup
run_backup() {
    echo -e "${BLUE} Cambios detectados, ejecutando respaldo...${NC}"
    $HOME/docfiles/scripts/backup.sh
    git add . 2>/dev/null
    git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
    echo -e "${GREEN} Respaldo automatico completado${NC}"
}

# Monitoreo continuo con inotifywait
while true; do
    if command -v inotifywait &> /dev/null; then
        inotifywait -q -r -e modify,create,delete,move \
            "${WATCH_DIRS[@]}" \
            "${HOME_FILES[@]}" \
            2>/dev/null | while read line; do
            run_backup
        done
    else
        echo -e "${RED} inotifywait no esta instalado. Instalalo con:${NC}"
        echo -e "${YELLOW}sudo pacman -S inotify-tools${NC}"
        echo -e "${YELLOW}Monitoreo simple cada 60 segundos...${NC}"
        
        # Monitoreo simple por intervalos
        LAST_HASH=$(find "${WATCH_DIRS[@]}" "${HOME_FILES[@]}" -type f -exec md5sum {} \; 2>/dev/null | sort | md5sum)
        while true; do
            sleep 60
            CURRENT_HASH=$(find "${WATCH_DIRS[@]}" "${HOME_FILES[@]}" -type f -exec md5sum {} \; 2>/dev/null | sort | md5sum)
            if [ "$LAST_HASH" != "$CURRENT_HASH" ]; then
                LAST_HASH="$CURRENT_HASH"
                run_backup
            fi
        done
    fi
done
