
## 🔧 Dependencies Required
```bash
# Instalar pavucontrol 
sudo pacman -S pavucontrol
# Core system tools
brightnessctl networkmanager pulseaudio lm_sensors
# Servicio Bluetooth está inactivo
sudo systemctl start bluetooth
sudo systemctl enable bluetooth  # Para que inicie automáticamente

# Fonts
ttf-firacode-nerd noto-fonts-emoji

# Applications (for click actions)
pavucontrol nm-connection-editor gnome-calendar
```
### Instalar Dependencias
```bash

# para las fuentes
sudo pacman -S ttf-firacode-nerd noto-fonts-emoji
# Para los módulos personalizados(revizar si ya estan instaladas)
#Sudo pacman -S swaync playerctl lm_sensors
# Para las aplicaciones de click(Si no se puede crear uno personalmente)
sudo pacman -S pavucontrol gnome-calendar
```
## Comandos para dar permisos a los archivos de scripts
### 1. Dar permisos
chmod +x ~/.config/waybar/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.py
### 2. Probar scripts manualmente
python ~/.config/waybar/scripts/music-visualizer.py
bash ~/.config/waybar/scripts/bluetooth-simple.sh

### 4. Recargar Waybar
killall -9 waybar
waybar -c ~/.config/waybar/config.jsonc & 

### Controles para waybar volumen
<i>🖱️ Left-click: Pavucontrol UI</i>"
<i>🖱️ Scroll ↑: Subir volumen (+5%)</i>
<i>🖱️ Scroll ↓: Bajar volumen (-5%)</i>
<i>🖱️ Right-click: Mutear/Desmutear</i>"

### Instalar paquetes para Bluetooth
```bash

# Paquetes esenciales de Bluetooth
sudo pacman -S bluez bluez-utils blueman

# Para audio Bluetooth (opcional pero recomendado)
sudo pacman -S pulseaudio-bluetooth

# Para interfaz gráfica (similar a GNOME)
sudo pacman -S blueman```
