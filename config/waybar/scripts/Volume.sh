#!/bin/bash

sDIR="$HOME/.config/waybar/scripts"

# Get Volume
get_volume() {
    volume=$(pamixer --get-volume)
    if [[ "$volume" -eq "0" ]] || [[ "$(pamixer --get-mute)" == "true" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Get Volume Icon (FontAwesome)
get_icon() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        echo "" # fa-volume-mute
    elif [[ "$(pamixer --get-volume)" -le 30 ]]; then
        echo "" # fa-volume-low
    elif [[ "$(pamixer --get-volume)" -le 60 ]]; then
        echo "" # fa-volume-down
    else
        echo "" # fa-volume-up
    fi
}

# Notify Volume
notify_user() {
    if [[ "$(get_volume)" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low " Volume:" "Muted"
    else
        notify-send -e -h int:value:"$(pamixer --get-volume)" -h string:x-canonical-private-synchronous:volume_notif -u low "$(get_icon) Volume:" "$(get_volume)"
        # Solo ejecutar sonidos si el archivo existe
        if [[ -f "$sDIR/Sounds.sh" ]]; then
            "$sDIR/Sounds.sh" --volume
        fi
    fi
}

# Increase Volume
inc_volume() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 150 && notify_user
    fi
}

# Decrease Volume
dec_volume() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -d 5 && notify_user
    fi
}

# Toggle Mute
toggle_mute() {
    if [[ "$(pamixer --get-mute)" == "false" ]]; then
        pamixer -m && notify-send -e -u low " Volume:" "Muted"
    else
        pamixer -u && notify-send -e -u low "$(get_icon) Volume:" "Switched ON"
    fi
}

# Get Microphone Volume
get_mic_volume() {
    volume=$(pamixer --default-source --get-volume)
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]] || [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Get Microphone Icon (FontAwesome)
get_mic_icon() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]] || [[ "$(pamixer --default-source --get-volume)" -eq "0" ]]; then
        echo " " # fa-microphone-slash
    else
        echo "" # fa-microphone
    fi
}

# Toggle Microphone
toggle_mic() {
    if [[ "$(pamixer --default-source --get-mute)" == "false" ]]; then
        pamixer --default-source -m && notify-send -e -u low " Microphone:" "Switched OFF"
    else
        pamixer -u --default-source && notify-send -e -u low " Microphone:" "Switched ON"
    fi
}

# Notify Microphone
notify_mic_user() {
    volume=$(get_mic_volume)
    icon=$(get_mic_icon)
    if [[ "$volume" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:mic_notif -u low "$icon Mic:" "Muted"
    else
        notify-send -e -h int:value:"$(pamixer --default-source --get-volume)" -h string:x-canonical-private-synchronous:mic_notif -u low "$icon Mic:" "$volume"
    fi
}

# Increase Microphone Volume
inc_mic_volume() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        toggle_mic
    else
        pamixer --default-source -i 5 && notify_mic_user
    fi
}

# Decrease Microphone Volume
dec_mic_volume() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        toggle_mic
    else
        pamixer --default-source -d 5 && notify_mic_user
    fi
}

# Playerctl Next
playerctl_next() {
    if command -v playerctl >/dev/null 2>&1; then
        playerctl next
        sleep 0.1
        artist=$(playerctl metadata artist 2>/dev/null || echo "Unknown")
        title=$(playerctl metadata title 2>/dev/null || echo "Unknown")
        notify-send -e -u low " Next:" "$artist - $title"
    else
        notify-send -e -u normal " Error:" "playerctl not installed"
    fi
}

# Playerctl Previous
playerctl_previous() {
    if command -v playerctl >/dev/null 2>&1; then
        playerctl previous
        sleep 0.1
        artist=$(playerctl metadata artist 2>/dev/null || echo "Unknown")
        title=$(playerctl metadata title 2>/dev/null || echo "Unknown")
        notify-send -e -u low " Previous:" "$artist - $title"
    else
        notify-send -e -u normal " Error:" "playerctl not installed"
    fi
}

# Playerctl Play/Pause Toggle
playerctl_toggle() {
    if command -v playerctl >/dev/null 2>&1; then
        playerctl play-pause
        sleep 0.1
        status=$(playerctl status 2>/dev/null || echo "No player")
        artist=$(playerctl metadata artist 2>/dev/null || echo "Unknown")
        title=$(playerctl metadata title 2>/dev/null || echo "Unknown")
        
        # Icono según el estado
        if [[ "$status" == "Playing" ]]; then
            icon=""
        else
            icon=""
        fi
        
        notify-send -e -u low "$icon $status:" "$artist - $title"
    else
        notify-send -e -u normal " Error:" "playerctl not installed"
    fi
}

# Execute commands
case "$1" in
    "--get")
        get_volume
        ;;
    "--inc")
        inc_volume
        ;;
    "--dec")
        dec_volume
        ;;
    "--toggle")
        toggle_mute
        ;;
    "--toggle-mic")
        toggle_mic
        ;;
    "--get-icon")
        get_icon
        ;;
    "--get-mic-icon")
        get_mic_icon
        ;;
    "--mic-inc")
        inc_mic_volume
        ;;
    "--mic-dec")
        dec_mic_volume
        ;;
    "--playerctl-next")
        playerctl_next
        ;;
    "--playerctl-previous")
        playerctl_previous
        ;;
    "--playerctl-toggle")
        playerctl_toggle
        ;;
    *)
        get_volume
        ;;
esac
