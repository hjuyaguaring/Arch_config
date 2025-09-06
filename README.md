
# Arch Linux Hyprland Dotfiles

Configuración personalizada de Arch Linux con Hyprland para un flujo de trabajo productivo.

## 🚀 Características

- Hyprland como compositor de ventanas
- Kitty como terminal
- Waybar para la barra de estado
- Configuraciones optimizadas para productividad

## 📦 Instalación en nuevo sistema

### Prerrequisitos
```bash
# Instalar git y herramientas básicas
sudo pacman -S git base-devel

# Instalar (AUR )
mkdir repos
cd repos
git clone https://aur.archlinux.org/paru-bin.git 
cd paru-bin/
makepkg -si
"colocar la password del admin y pulsar S"
#Instalar YAY (si lo necesita)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
