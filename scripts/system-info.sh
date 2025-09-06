#!/bin/bash

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ANÁLISIS DE COMPONENTES Y PLUGINS PARA WAYBAR ===${NC}"
echo ""

# Función para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 instalado"
        return 0
    else
        echo -e "${RED}✗${NC} $1 no instalado"
        return 1
    fi
}

# Función para verificar archivo
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 existe"
        return 0
    else
        echo -e "${RED}✗${NC} $1 no existe"
        return 1
    fi
}

# Información de la CPU
echo -e "${YELLOW}--- INFORMACIÓN DE LA CPU ---${NC}"
if check_command "lscpu"; then
    echo "  Modelo: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo "  Núcleos: $(nproc)"
    echo "  Hilos: $(lscpu | grep 'CPU(s):' | head -1 | awk '{print $2}')"
else
    echo "  Instala lscpu: ${BLUE}sudo pacman -S util-linux${NC}"
fi
echo ""

# Información de la GPU
echo -e "${YELLOW}--- INFORMACIÓN DE LA GPU ---${NC}"
if check_command "lspci"; then
    gpu_info=$(lspci | grep -i vga | cut -d':' -f3 | xargs)
    if [ -n "$gpu_info" ]; then
        echo "  GPU: $gpu_info"
        
        # Detectar si es NVIDIA
        if echo "$gpu_info" | grep -i nvidia > /dev/null; then
            echo "  Tipo: NVIDIA - Recomendado: nvidia-smi plugin"
            check_command "nvidia-smi"
        fi
        
        # Detectar si es AMD
        if echo "$gpu_info" | grep -i amd > /dev/null; then
            echo "  Tipo: AMD - Recomendado: amdgpu plugin"
            check_file "/sys/class/drm/card0/device/gpu_busy_percent"
        fi
        
        # Detectar si es Intel
        if echo "$gpu_info" | grep -i intel > /dev/null; then
            echo "  Tipo: Intel - Recomendado: intel_gpu_top plugin"
            check_command "intel_gpu_top"
        fi
    else
        echo "  No se detectó GPU dedicada"
    fi
else
    echo "  Instala lspci: ${BLUE}sudo pacman -S pciutils${NC}"
fi
echo ""

# Información de la memoria RAM
echo -e "${YELLOW}--- INFORMACIÓN DE MEMORIA RAM ---${NC}"
if check_command "free"; then
    total_mem=$(free -h | grep Mem | awk '{print $2}')
    echo "  Total: $total_mem"
else
    echo "  free no disponible"
fi
echo ""

# Información del almacenamiento
echo -e "${YELLOW}--- INFORMACIÓN DE ALMACENAMIENTO ---${NC}"
if check_command "lsblk"; then
    echo "  Discos:"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E '(disk|part)' | grep -v loop | while read -r line; do
        echo "    $line"
    done
    
    # Verificar plugin de disco
    echo ""
    echo "  Plugin disk:"
    check_file "/sys/class/block/sda/stat" || check_file "/sys/block/sda/stat"
else
    echo "  Instala lsblk: ${BLUE}sudo pacman -S util-linux${NC}"
fi
echo ""

# Información de la batería (para laptops)
echo -e "${YELLOW}--- INFORMACIÓN DE BATERÍA ---${NC}"
if [ -d /sys/class/power_supply ]; then
    batteries=$(find /sys/class/power_supply -name "BAT*")
    if [ -z "$batteries" ]; then
        echo "  No se detectó batería (sistema de escritorio)"
    else
        for bat in $batteries; do
            capacity=$(cat "$bat/capacity" 2>/dev/null || echo "N/A")
            status=$(cat "$bat/status" 2>/dev/null || echo "N/A")
            echo "  Batería $(basename $bat): $capacity% ($status)"
        done
        echo "  Plugin battery: ${GREEN}Disponible${NC}"
    fi
else
    echo "  No se detectó sistema de energía"
fi
echo ""

# Información de red
echo -e "${YELLOW}--- INFORMACIÓN DE RED ---${NC}"
if check_command "ip"; then
    echo "  Interfaces:"
    ip link show | grep -E '^[0-9]+:' | awk -F': ' '{print $2}' | while read -r intf; do
        if [ "$intf" != "lo" ]; then
            echo "    $intf"
        fi
    done
    
    # Verificar si hay conexión WiFi
    if ip link show | grep -i wireless > /dev/null; then
        echo "  WiFi: ${GREEN}Disponible${NC}"
        check_command "iwctl"
    fi
    
    # Verificar si hay conexión Ethernet
    if ip link show | grep -E '(eth|enp)' > /dev/null; then
        echo "  Ethernet: ${GREEN}Disponible${NC}"
    fi
else
    echo "  ip no disponible"
fi
echo ""

# Información de audio
echo -e "${YELLOW}--- INFORMACIÓN DE AUDIO ---${NC}"
if check_command "pactl"; then
    sinks=$(pactl list short sinks | awk '{print $2}')
    echo "  Dispositivos de salida:"
    echo "$sinks" | while read -r sink; do
        echo "    $sink"
    done
    echo "  Plugin pulseaudio: ${GREEN}Disponible${NC}"
else
    echo "  Instala pactl: ${BLUE}sudo pacman -S pulseaudio-utils${NC}"
fi
echo ""

# Información de temperatura
echo -e "${YELLOW}--- INFORMACIÓN DE TEMPERATURA ---${NC}"
if [ -f "/sys/class/thermal/thermal_zone0/temp" ]; then
    temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    echo "  Temperatura CPU: $((temp/1000))°C"
    echo "  Plugin temperature: ${GREEN}Disponible${NC}"
else
    echo "  No se detectaron sensores de temperatura"
    check_command "sensors" || echo "  Instala lm_sensors: ${BLUE}sudo pacman -S lm_sensors${NC}"
fi
echo ""

# Verificar Waybar y plugins
echo -e "${YELLOW}--- VERIFICACIÓN DE WAYBAR Y PLUGINS ---${NC}"
if check_command "waybar"; then
    echo "  Waybar: $(waybar --version | head -n1 2>/dev/null || echo 'Instalado')"
    
    # Verificar módulos de Waybar
    echo ""
    echo "  Módulos disponibles:"
    
    # Verificar módulo de workspaces para Hyprland
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "    hyprland/workspaces: ${GREEN}Disponible${NC}"
    else
        echo "    hyprland/workspaces: ${RED}No disponible (¿Hyprland ejecutándose?)${NC}"
    fi
    
    # Verificar módulo de reloj (siempre disponible)
    echo "    clock: ${GREEN}Disponible${NC}"
    
    # Verificar otros módulos comunes
    check_command "mpstat" && echo "    cpu: ${GREEN}Disponible${NC}" || echo "    cpu: ${YELLOW}Instala sysstat: sudo pacman -S sysstat${NC}"
    
    check_command "free" && echo "    memory: ${GREEN}Disponible${NC}" || echo "    memory: ${RED}No disponible${NC}"
else
    echo "  Waybar no instalado: ${BLUE}sudo pacman -S waybar${NC}"
fi
echo ""

# Resumen de instalación recomendada
echo -e "${YELLOW}--- RESUMEN DE INSTALACIÓN RECOMENDADA ---${NC}"
if ! check_command "waybar"; then
    echo "  waybar: ${BLUE}sudo pacman -S waybar${NC}"
fi

if ! check_command "pactl"; then
    echo "  pulseaudio-utils: ${BLUE}sudo pacman -S pulseaudio-utils${NC}"
fi

if ! check_command "sensors"; then
    echo "  lm_sensors: ${BLUE}sudo pacman -S lm_sensors${NC}"
fi

if ! check_command "mpstat"; then
    echo "  sysstat: ${BLUE}sudo pacman -S sysstat${NC}"
fi

if ! check_command "lspci"; then
    echo "  pciutils: ${BLUE}sudo pacman -S pciutils${NC}"
fi

if ! check_command "lscpu"; then
    echo "  util-linux: ${BLUE}sudo pacman -S util-linux${NC}"
fi

echo ""
echo -e "${GREEN}Análisis completado. Revisa las recomendaciones arriba.${NC}"
