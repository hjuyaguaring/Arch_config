#!/usr/bin/env python3
"""
Bluetooth Enhanced Script para Waybar
Compatible con Font Awesome, Wofi/Rofi, y paquetes estándar de Arch Linux
Autor: Optimizado para Hyprland + Waybar
"""

import json
import subprocess
import sys
import os
import time

class BluetoothManager:
    def __init__(self):
        self.bluetoothctl_path = self._find_bluetoothctl()
    
    def _find_bluetoothctl(self):
        """Buscar bluetoothctl en ubicaciones comunes"""
        common_paths = [
            '/usr/bin/bluetoothctl',
            '/bin/bluetoothctl', 
            '/usr/local/bin/bluetoothctl'
        ]
        
        # Verificar paths comunes
        for path in common_paths:
            if os.path.exists(path):
                return path
        
        # Usar 'which' como respaldo
        try:
            result = subprocess.run(['which', 'bluetoothctl'], 
                                  capture_output=True, text=True, timeout=2)
            if result.returncode == 0:
                return result.stdout.strip()
        except:
            pass
        
        return None
    
    def _run_command(self, cmd, timeout=3):
        """Ejecutar comando con manejo robusto de errores"""
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, 
                                  timeout=timeout, check=False)
            return result.returncode == 0, result.stdout.strip(), result.stderr.strip()
        except subprocess.TimeoutExpired:
            return False, "", "Timeout"
        except FileNotFoundError:
            return False, "", "Command not found"
        except Exception as e:
            return False, "", str(e)
    
    def is_available(self):
        """Verificar si bluetooth está disponible"""
        return self.bluetoothctl_path is not None
    
    def get_status(self):
        """Obtener estado completo del bluetooth"""
        if not self.is_available():
            return {
                'available': False,
                'powered': False,
                'connected_devices': [],
                'error': 'bluetoothctl not found'
            }
        
        # Obtener información básica
        success, output, error = self._run_command([self.bluetoothctl_path, 'show'])
        
        if not success:
            return {
                'available': True,
                'powered': False,
                'connected_devices': [],
                'error': f'bluetoothctl failed: {error}'
            }
        
        is_powered = "Powered: yes" in output
        connected_devices = []
        
        # Obtener dispositivos conectados si está encendido
        if is_powered:
            success, devices_output, _ = self._run_command(
                [self.bluetoothctl_path, 'devices', 'Connected']
            )
            
            if success and devices_output:
                for line in devices_output.split('\n'):
                    line = line.strip()
                    if line and line.startswith('Device'):
                        parts = line.split(' ', 2)
                        if len(parts) >= 3:
                            # parts[0] = "Device", parts[1] = MAC, parts[2] = Name
                            device_info = {
                                'mac': parts[1],
                                'name': parts[2]
                            }
                            connected_devices.append(device_info)
        
        return {
            'available': True,
            'powered': is_powered,
            'connected_devices': connected_devices,
            'error': None
        }
    
    def toggle_power(self):
        """Alternar encendido/apagado del bluetooth"""
        if not self.is_available():
            return False
        
        status = self.get_status()
        new_state = 'off' if status['powered'] else 'on'
        
        success, _, _ = self._run_command([self.bluetoothctl_path, 'power', new_state])
        return success
    
    def start_scan(self):
        """Iniciar escaneo de dispositivos"""
        if not self.is_available():
            return False
        
        success, _, _ = self._run_command([self.bluetoothctl_path, 'scan', 'on'])
        return success

class MenuManager:
    def __init__(self):
        self.menu_cmd = self._find_menu_program()
    
    def _find_menu_program(self):
        """Encontrar programa de menú disponible"""
        if os.path.exists('/usr/bin/wofi'):
            return ['wofi', '--dmenu', '--prompt', 'Bluetooth', '--width', '300']
        elif os.path.exists('/usr/bin/rofi'):
            return ['rofi', '-dmenu', '-p', 'Bluetooth', '-width', '25']
        return None
    
    def show_menu(self, bt_manager):
        """Mostrar menú contextual interactivo"""
        if not self.menu_cmd:
            # Fallback: abrir blueman directamente
            self._open_blueman()
            return
        
        status = bt_manager.get_status()
        
        if not status['available']:
            return
        
        # Construir opciones del menú
        options = []
        commands = []
        
        if status['powered']:
            options.append("🔴 Desactivar Bluetooth")
            commands.append('toggle')
            
            options.append("🔍 Buscar dispositivos")
            commands.append('scan')
            
            options.append("⚙️  Administrador de Bluetooth")
            commands.append('blueman')
            
            if status['connected_devices']:
                options.append("━━━━━━━━━━━━━━━━━━━━")
                commands.append('')
                
                options.append(f"📱 Dispositivos conectados ({len(status['connected_devices'])}):")
                commands.append('')
                
                for device in status['connected_devices'][:4]:  # Máximo 4 dispositivos
                    options.append(f"   • {device['name']}")
                    commands.append('')
                
                if len(status['connected_devices']) > 4:
                    options.append(f"   • ... y {len(status['connected_devices']) - 4} más")
                    commands.append('')
        else:
            options.append("🟢 Activar Bluetooth")
            commands.append('toggle')
            
            options.append("⚙️  Administrador de Bluetooth")
            commands.append('blueman')
        
        # Mostrar menú
        menu_text = '\n'.join(options)
        
        try:
            result = subprocess.run(
                self.menu_cmd + ['--lines', str(len(options))],
                input=menu_text, 
                text=True, 
                capture_output=True,
                timeout=10
            )
            
            if result.returncode == 0 and result.stdout.strip():
                selected = result.stdout.strip()
                self._execute_menu_action(selected, options, commands, bt_manager)
                
        except (subprocess.TimeoutExpired, Exception):
            # En caso de error, abrir blueman como respaldo
            self._open_blueman()
    
    def _execute_menu_action(self, selected, options, commands, bt_manager):
        """Ejecutar acción seleccionada del menú"""
        try:
            index = options.index(selected)
            command = commands[index]
            
            if command == 'toggle':
                bt_manager.toggle_power()
                time.sleep(0.5)  # Pequeña pausa para que el cambio se registre
            elif command == 'scan':
                bt_manager.start_scan()
                self._open_blueman()
            elif command == 'blueman':
                self._open_blueman()
                
        except (ValueError, IndexError):
            pass
    
    def _open_blueman(self):
        """Abrir administrador de Bluetooth (Blueman)"""
        try:
            subprocess.Popen(['blueman-manager'], start_new_session=True)
        except FileNotFoundError:
            # Si blueman no está disponible, intentar con settings de bluetooth
            try:
                subprocess.Popen(['bluetooth-settings'], start_new_session=True)
            except FileNotFoundError:
                pass

class WaybarOutput:
    def __init__(self):
        self.icons = {
            'enabled': '',      # Font Awesome bluetooth
            'disabled': '',     # Font Awesome bluetooth disabled  
            'connected': '',    # Font Awesome bluetooth
            'error': '',        # Font Awesome bluetooth disabled
            'missing': ''       # Font Awesome bluetooth disabled
        }
    
    def generate_output(self, bt_manager):
        """Generar output JSON para Waybar"""
        status = bt_manager.get_status()
        
        # Bluetooth no disponible
        if not status['available']:
            return {
                "text": self.icons['missing'],
                "tooltip": "Bluetooth no disponible\n\n💡 Instala: sudo pacman -S bluez bluez-utils\n🖱️ Click: Menú",
                "class": "missing"
            }
        
        # Error de conexión
        if status['error']:
            return {
                "text": self.icons['error'],
                "tooltip": f"Error: {status['error']}\n🖱️ Click: Menú",
                "class": "error"
            }
        
        # Bluetooth apagado
        if not status['powered']:
            return {
                "text": self.icons['disabled'],
                "tooltip": "Bluetooth desactivado\n\n🖱️ Click: Menú\n🖱️ Middle-click: Activar\n🖱️ Right-click: Blueman",
                "class": "disabled"
            }
        
        # Bluetooth encendido con dispositivos
        connected_count = len(status['connected_devices'])
        
        if connected_count > 0:
            tooltip = f"Bluetooth activo\n{connected_count} dispositivo{'s' if connected_count != 1 else ''} conectado{'s' if connected_count != 1 else ''}\n\n"
            
            # Mostrar hasta 3 dispositivos en el tooltip
            device_names = [dev['name'] for dev in status['connected_devices'][:3]]
            tooltip += "Dispositivos:\n" + '\n'.join(f"• {name}" for name in device_names)
            
            if connected_count > 3:
                tooltip += f"\n• ... y {connected_count - 3} más"
            
            tooltip += "\n\n🖱️ Click: Menú\n🖱️ Middle-click: Desactivar\n🖱️ Right-click: Blueman"
            
            return {
                "text": f"{self.icons['connected']} {connected_count}",
                "tooltip": tooltip,
                "class": "connected"
            }
        
        # Bluetooth encendido sin dispositivos
        return {
            "text": self.icons['enabled'],
            "tooltip": "Bluetooth activo\nSin dispositivos conectados\n\n🖱️ Click: Menú\n🖱️ Middle-click: Desactivar\n🖱️ Right-click: Blueman",
            "class": "enabled"
        }

def handle_click(button):
    """Manejar clicks de Waybar"""
    bt_manager = BluetoothManager()
    menu_manager = MenuManager()
    
    if button == "1":  # Click izquierdo - mostrar menú
        menu_manager.show_menu(bt_manager)
    elif button == "2":  # Click medio - toggle rápido
        bt_manager.toggle_power()
    elif button == "3":  # Click derecho - abrir blueman
        menu_manager._open_blueman()

def main():
    """Función principal"""
    if len(sys.argv) > 1:
        # Modo click - manejar interacción del usuario
        handle_click(sys.argv[1])
    else:
        # Modo status - generar JSON para waybar
        try:
            bt_manager = BluetoothManager()
            waybar_output = WaybarOutput()
            result = waybar_output.generate_output(bt_manager)
            print(json.dumps(result))
        except Exception as e:
            # Fallback en caso de error crítico
            fallback = {
                "text": "",
                "tooltip": f"Error crítico: {str(e)}",
                "class": "error"
            }
            print(json.dumps(fallback))

if __name__ == "__main__":
    main()
