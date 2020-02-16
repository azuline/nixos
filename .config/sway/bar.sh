#!/usr/bin/env bash

# Date/Time

datetime="$(date +"%Y-%m-%d %l:%M:%S %p")"

# Load

loadavg="  $(cat /proc/loadavg | awk -F ' ' '{print $1, $2, $3}')"

# Network

network_ssid=$(iwgetid -r)
network="  $([ $network_ssid = "" ] && echo "n/a" || echo "$network_ssid")"

# Battery

battery_name=$(upower --enumerate | grep "BAT")
case $(upower --show-info $battery_name | egrep "state" | awk '{print $2}') in
    "fully_charged")    battery_icon="" ;;
    "charging")         battery_icon="" ;;
    *)                  battery_icon="" ;;
esac
battery="$battery_icon  $(upower --show-info $battery_name | egrep "percentage" | awk '{print $2}')"

# Audio

audio_muted=$(pacmd list-sinks | awk '/muted/ { print $2 }')
if [ $audio_muted = "yes" ]; then
	audio="  muted"
else
    audio_volume=$(amixer sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }')
    audio="  $audio_volume"
fi

# Brightness

brightness="  $(($(cat /sys/class/backlight/intel_backlight/brightness) * 100 / $(cat /sys/class/backlight/intel_backlight/max_brightness)))%"

# Wireguard

wireguard="  $(wg show interfaces | sed 's/ / • /')"

# Bluetooth

IFS='\n'
bluetooth=" "
for dev in $(bluetoothctl paired-devices); do
    bt_mac=$(echo $dev | awk 'NF=2{print $NF}')
    bt_name=$(echo $dev | awk 'NF=3{print $NF}')
    bt_connected=$(bluetoothctl info "$bt_mac" | grep "Connected: yes")
    if [[ -n "$bt_connected" ]]; then
        bluetooth="${bluetooth} ${bt_name}"
    fi
done

echo "$bluetooth  $wireguard  $loadavg  $brightness  $audio  $network  $battery  |  $datetime  "
