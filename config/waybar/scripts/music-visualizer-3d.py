#!/usr/bin/env python3

import json
import subprocess
import random
import os

class MediaControls:
    def __init__(self):
        # Frases para cuando no hay audio
        self.idle_messages = [
            " ", 
            "🎹 Esperando melodías",
        ]

    def check_audio_playing(self):
        """Verifica si hay audio reproduciéndose usando PulseAudio"""
        try:
            # Método 1: Verificar sink-inputs de PulseAudio (la forma más directa)
            try:
                result = subprocess.run(['pacmd', 'list-sink-inputs'], 
                                      capture_output=True, text=True, timeout=2)
                
                if result.returncode == 0:
                    # Buscar líneas que indiquen que hay audio activo
                    output = result.stdout
                    
                    # Si hay al menos un sink-input, hay audio reproduciéndose
                    # Incluso si está en estado CORKED (que es común con navegadores)
                    if 'index:' in output:
                        return True
            except:
                pass
            
            # Método 2: Alternativa con pactl (por si pacmd no está disponible)
            try:
                result = subprocess.run(['pactl', 'list', 'short', 'sink-inputs'], 
                                      capture_output=True, text=True, timeout=2)
                
                if result.returncode == 0 and result.stdout.strip():
                    # Si hay líneas en la salida, hay audio reproduciéndose
                    return True
            except:
                pass
                
            # Método 3: Verificar si hay algún reproductor activo con playerctl
            try:
                players = subprocess.run(['playerctl', '-l'], 
                                       capture_output=True, text=True, timeout=1)
                if players.returncode == 0 and players.stdout.strip():
                    status = subprocess.run(['playerctl', 'status'], 
                                          capture_output=True, text=True, timeout=1)
                    if status.returncode == 0 and status.stdout.strip() in ['Playing', 'Paused']:
                        return True
            except:
                pass
                
            return False
            
        except Exception as e:
            print(f"Error checking audio: {e}")
            return False

    def get_media_controls(self):
        """Genera controles de media si playerctl está disponible"""
        try:
            # Verificar si playerctl está disponible y hay un player activo
            status = subprocess.run(['playerctl', 'status'], 
                                  capture_output=True, text=True, timeout=1)
            if status.returncode == 0:
                current_status = status.stdout.strip()
                if current_status == "Playing":
                    return "     "
                elif current_status == "Paused":
                    return "     "
        except Exception:
            pass
        
        return ""

    def get_music_info(self):
        """Obtiene información de la música actual"""
        try:
            # Primero intentar con playerctl
            player_status = subprocess.run(['playerctl', 'status'], 
                                         capture_output=True, text=True, timeout=2)
            if player_status.returncode == 0 and player_status.stdout.strip() in ['Playing', 'Paused']:
                try:
                    artist = subprocess.run(['playerctl', 'metadata', 'artist'], 
                                          capture_output=True, text=True, timeout=2)
                    title = subprocess.run(['playerctl', 'metadata', 'title'], 
                                         capture_output=True, text=True, timeout=2)
                    
                    if artist.returncode == 0 and title.returncode == 0:
                        artist_name = artist.stdout.strip()
                        title_name = title.stdout.strip()
                        if artist_name and title_name:
                            return f"{artist_name} - {title_name}"
                        elif title_name:
                            return title_name
                        else:
                            return "Música en reproducción"
                except Exception:
                    return "Música en reproducción"
            
            # Si playerctl no funciona, intentar obtener info de PulseAudio
            try:
                result = subprocess.run(['pacmd', 'list-sink-inputs'], 
                                      capture_output=True, text=True, timeout=2)
                if result.returncode == 0:
                    output = result.stdout
                    if 'media.name = "' in output:
                        # Extraer el nombre del medio
                        start_idx = output.find('media.name = "') + len('media.name = "')
                        end_idx = output.find('"', start_idx)
                        media_name = output[start_idx:end_idx]
                        if media_name:
                            return media_name
            except:
                pass
                
        except Exception:
            pass
        
        return "Audio activo"

    def generate_output(self):
        """Genera la salida principal"""
        is_playing = self.check_audio_playing()
        
        if is_playing:
            # Obtener controles de media
            controls = self.get_media_controls()
            
            # Obtener información de música
            music_info = self.get_music_info()
            
            return {
                "text": controls,
                "tooltip": f"{music_info}\n",
                "class": "playing"
            }
        else:
            # Mostrar mensaje cuando no hay audio
            idle_msg = random.choice(self.idle_messages)
            return {
                "text": idle_msg,
                "tooltip": "💤 No se detecta audio\n\n🎧 Reproduce algo para ver los controles",
                "class": "idle"
            }

def main():
    try:
        media_controls = MediaControls()
        output = media_controls.generate_output()
        print(json.dumps(output))
    except Exception as e:
        # Fallback en caso de error
        error_output = {
            "text": "🎵 Audio Monitor",
            "tooltip": f"Error: {str(e)}",
            "class": "error"
        }
        print(json.dumps(error_output))

if __name__ == "__main__":
    main()
