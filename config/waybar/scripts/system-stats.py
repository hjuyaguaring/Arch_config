#!/usr/bin/env python3

import json
import subprocess
import re
import os

def get_cpu_usage():
    try:
        # Método más confiable para CPU usando /proc/stat
        with open('/proc/stat', 'r') as f:
            first_line = f.readline().strip()
        
        if first_line.startswith('cpu '):
            values = first_line.split()
            user = int(values[1])
            nice = int(values[2])
            system = int(values[3])
            idle = int(values[4])
            iowait = int(values[5])
            irq = int(values[6])
            softirq = int(values[7])
            steal = int(values[8])
            
            # Calcular total y idle
            total = user + nice + system + idle + iowait + irq + softirq + steal
            idle_total = idle + iowait
            
            # Leer valor anterior para calcular diferencia
            try:
                with open('/tmp/cpu_prev.txt', 'r') as f:
                    prev_total, prev_idle = map(int, f.read().split())
            except:
                prev_total, prev_idle = total, idle_total
            
            # Guardar valores actuales para next time
            with open('/tmp/cpu_prev.txt', 'w') as f:
                f.write(f"{total} {idle_total}")
            
            # Calcular uso porcentual
            total_diff = total - prev_total
            idle_diff = idle_total - prev_idle
            
            if total_diff > 0:
                usage = 100.0 * (total_diff - idle_diff) / total_diff
                return f"{usage:.0f}%"
            else:
                return "0%"
                
    except Exception as e:
        return "N/A"
def get_memory_usage():
    try:
        with open('/proc/meminfo', 'r') as f:
            lines = f.readlines()

        meminfo = {}
        for line in lines:
            if ':' in line:
                key, value = line.split(':', 1)
                meminfo[key.strip()] = value.strip()

        if 'MemTotal' in meminfo and 'MemAvailable' in meminfo:
            total_kb = int(meminfo['MemTotal'].split()[0])
            available_kb = int(meminfo['MemAvailable'].split()[0])
            used_kb = total_kb - available_kb
            used_gb = used_kb / 1024 / 1024
            return f"{used_gb:.1f}G"
    except Exception as e:
        # print(f"Memory Error: {e}", file=sys.stderr)
        return "N/A"
def get_temperature():
    try:
        # Intentar diferentes paths de temperatura
        temp_paths = [
            '/sys/class/thermal/thermal_zone0/temp',
            '/sys/class/hwmon/hwmon0/temp1_input',
            '/sys/class/hwmon/hwmon1/temp1_input',
            '/sys/class/hwmon/hwmon2/temp1_input'
        ]
        
        for path in temp_paths:
            try:
                with open(path, 'r') as f:
                    temp = int(f.read().strip())
                    if temp > 1000:  # Si está en millidegrees
                        temp = temp / 1000
                    return f"{temp:.0f}°C"
            except:
                continue
                
        # Fallback: usar sensors command
        try:
            result = subprocess.run(['sensors'], capture_output=True, text=True, timeout=2)
            if result.returncode == 0:
                # Buscar temperatura en output
                for line in result.stdout.split('\n'):
                    if 'Core 0' in line or 'Package id 0' in line or 'temp1' in line:
                        if '+' in line and '°C' in line:
                            temp_str = line.split('+')[1].split('°C')[0]
                            return f"{temp_str}°C"
        except:
            pass
            
        return "N/A"
    except Exception as e:
        return "N/A"

def get_color_for_value(value_str, thresholds):
    """Devuelve color basado en umbrales"""
    try:
        value = float(value_str.replace('%', '').replace('°C', '').replace('G', ''))
        if value < thresholds[0]:
            return '#a6e3a1'  # Verde (bajo)
        elif value < thresholds[1]:
            return '#f9e2af'  # Amarillo (medio)
        else:
            return '#f38ba8'  # Rojo (alto)
    except:
        return '#cdd6f4'  # Blanco por defecto

def main():
    cpu = get_cpu_usage()
    mem_usage = get_memory_usage()
    temp = get_temperature()
    
    # Validar que los valores no sean None
    cpu = cpu if cpu is not None else "N/A"
    mem_usage = mem_usage if mem_usage is not None else "N/A"
    # mem_percent = mem_percent if mem_percent is not None else "N/A"
    temp = temp if temp is not None else "N/A"
    
    # Obtener colores basados en valores
    cpu_color = get_color_for_value(cpu, [50, 80])  # 50%, 80%
    mem_color = get_color_for_value(mem_usage, [60, 85])  # 60%, 85%
    temp_color = get_color_for_value(temp, [60, 80])  # 60°C, 80°C
    

    # Calcular el ancho máximo de la línea inferior
    bottom_line = f"{mem_usage}{temp}"
    bottom_width = len(bottom_line)

    # Calcular espacios necesarios para centrar CPU
    cpu_text = f"  {cpu}"
    spaces_needed = max(0, (bottom_width - len(cpu_text)) // 2)
    cpu_centered = "  " * spaces_needed + cpu_text
    # Layout triangular: CPU arriba, MEM izq, TEMP der
    # triangular_layout = f"""<span>\t<span color='{cpu_color}'>  {cpu}</span>
    # <span color='{mem_color}'>  {mem_usage}</span>\t<span color='{temp_color}'>  {temp}</span></span>"""
    # triangular_layout = f"""<span><span color='{cpu_color}'> {cpu_centered}</span>
# <span color='{mem_color}'> {mem_usage}</span>\t<span color='{temp_color}'>{temp}</span></span>"""

    triangular_layout = f"<span color='{cpu_color}'> {cpu}</span> <span color='{mem_color}'>   {mem_usage}</span> <span color='{temp_color}'> {temp}</span>"
    
    # Tooltip detallado con información del sistema
    cpu_padded = str(cpu).ljust(6)
    mem_usage_padded = str(mem_usage).ljust(6)
    temp_padded = str(temp).ljust(6)
    
    tooltip_text = f"""<b>📊 Monitoreo del Sistema</b>
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ <span color='{cpu_color}'>   CPU:    {cpu_padded} </span>          ┃
┃ <span color='{mem_color}'>   RAM:    {mem_usage_padded}</span>  ┃
┃ <span color='{temp_color}'>  TEMP:   {temp_padded}</span>          ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

<i>Layout: ▲ CPU | RAM TEMP</i>
<i>Click para abrir htop</i>"""
    
    print(json.dumps({
        "text": triangular_layout,
        "tooltip": tooltip_text,
        "class": "system-stats-triangle"
    }))
if __name__ == "__main__":
    main()
