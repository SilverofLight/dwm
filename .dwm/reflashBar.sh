#!/bin/bash

temp_date="$HOME/.dwm/tmp/date"
temp_mem="$HOME/.dwm/tmp/mem"
temp_storage="$HOME/.dwm/tmp/storage"
temp_battery="$HOME/.dwm/tmp/battery"
temp_wifi="$HOME/.dwm/tmp/wifi"
temp_cpu="$HOME/.dwm/tmp/cpu"
temp_vol="$HOME/.dwm/tmp/vol"

# 考研倒计时
today=$(date "+%d")
thisMon=`expr 30 - $today + 21`

vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | cut -d'.' -f2) 

Vol=""
if [ $vol -ge 50 ]
then
  Vol="^b#cc6666^^c#11111b^  "
elif [ $vol -eq 0 ]
then
  Vol="^b#cc6666^^c#11111b^  "
else
  Vol="^b#cc6666^^c#11111b^  "
fi
MAC=$(bluetoothctl devices | grep -i Baseus | awk '{print $2}' | head -n 1)
Blue_bat=$(bluetoothctl info "$MAC" | grep Battery | awk '{print $4}' | tr -d '()')
if_con=$(bluetoothctl info "$MAC" | grep Connected | awk '{print $2}')

Blue_icon=""
if [ "$if_con" = "yes" ]; then
  case $Blue_bat in
    100)
      Blue_icon="^b#b87694^^c#11111b^ 󰥈 "
      ;;
    90)
      Blue_icon="^b#b87694^^c#11111b^ 󰥆 "
      ;;
    80)
      Blue_icon="^b#b87694^^c#11111b^ 󰥅 "
      ;;
    70)
      Blue_icon="^b#b87694^^c#11111b^ 󰥄 "
      ;;
    60)
      Blue_icon="^b#b87694^^c#11111b^ 󰥃 "
      ;;
    50)
      Blue_icon="^b#b87694^^c#11111b^ 󰥂 "
      ;;
    40)
      Blue_icon="^b#b87694^^c#11111b^ 󰥁 "
      ;;
    30)
      Blue_icon="^b#b87694^^c#11111b^ 󰥀 "
      ;;
    20)
      Blue_icon="^b#b87694^^c#11111b^ 󰤿 "
      ;;
    10)
      Blue_icon="^b#b87694^^c#11111b^ 󰤾 "
      ;;
    esac
else
  Blue_icon=""
fi
echo "$Blue_icon$Vol^c#cc6666^^b#1e1e2e^ $vol" > "$temp_vol"


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
# xsetroot -name "/ $storage |  $cpu |  $mem |  $battery% | $vol% |  $wifi | $date"
  xsetroot -name "^b#ff91af^^c#11111b^考研还剩：$thisMon ^c#11111b^^b#a6e3a1^ / ^b#1e1e2e^^c#a6e3a1^ $storage ^b#94e2d5^^c#11111b^  ^c#94e2d5^^b#1e1e2e^ $cpu ^c#11111b^^b#f9e2af^  ^c#f9e2af^^b#1e1e2e^ $mem ^b#89b4fa^^c#11111b^  ^b#1e1e2e^^c#89b4fa^ $battery% $vol% ^#b#49d980^^c#11111b^  ^c#49d980^^b#1e1e2e^ $wifi ^c#f0e0e6^^b#1e1e2e^ $date"
