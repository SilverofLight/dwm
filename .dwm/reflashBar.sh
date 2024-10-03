#!/bin/bash

temp_date="$HOME/.dwm/tmp/date"
temp_mem="$HOME/.dwm/tmp/mem"
temp_storage="$HOME/.dwm/tmp/storage"
temp_battery="$HOME/.dwm/tmp/battery"
temp_wifi="$HOME/.dwm/tmp/wifi"
temp_cpu="$HOME/.dwm/tmp/cpu"
temp_vol="$HOME/.dwm/tmp/vol"

# vol
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | cut -d'.' -f2) 

Vol=""
if [ $vol -ge 50 ]
then
  Vol=" "
elif [ $vol -eq 0 ]
then
  Vol=" "
else
  Vol=" "
fi
MAC=$(bluetoothctl devices | grep -i Baseus | awk '{print $2}' | head -n 1)
Blue_bat=$(bluetoothctl info "$MAC" | grep Battery | awk '{print $4}' | tr -d '()')
if_con=$(bluetoothctl info "$MAC" | grep Connected | awk '{print $2}')

Blue_icon=""
if [ "$if_con" = "yes" ]; then
  case $Blue_bat in
    100)
      Blue_icon="󰥈 "
      ;;
    90)
      Blue_icon="󰥆 "
      ;;
    80)
      Blue_icon="󰥅 "
      ;;
    70)
      Blue_icon="󰥄 "
      ;;
    60)
      Blue_icon="󰥃 "
      ;;
    50)
      Blue_icon="󰥂 "
      ;;
    40)
      Blue_icon="󰥁 "
      ;;
    30)
      Blue_icon="󰥀 "
      ;;
    20)
      Blue_icon="󰤿 "
      ;;
    10)
      Blue_icon="󰤾 "
      ;;
    esac
else
  Blue_icon=""
fi
echo "$Blue_icon$Vol$vol" > "$temp_vol"

if [[ -f "$temp_date" ]]; then
  date=$(cat $temp_date)
fi
if [[ -f "$temp_cpu" ]]; then
  cpu=$(cat $temp_cpu)
fi
if [[ -f "$temp_mem" ]]; then
  mem=$(cat $temp_mem)
fi
if [[ -f "$temp_storage" ]]; then
  storage=$(cat $temp_storage)
fi
if [[ -f "$temp_battery" ]]; then
  battery=$(cat $temp_battery)
fi
if [[ -f "$temp_wifi" ]]; then
  vol=$(cat $temp_vol)
fi
if [[ -f "$temp_vol" ]]; then
  wifi=$(cat $temp_wifi)
fi
xsetroot -name "/ $storage |  $cpu |  $mem |  $battery% | $vol% |  $wifi | $date"
