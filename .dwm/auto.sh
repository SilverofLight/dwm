#!/bin/bash

# feh --bg-fill ~/Pictures/wallpaper/wallhaven-qdmpz5.png &
picom --config ~/.config/picom/picom.config &

fcitx5 &
numlockx on &

while true; do
  ~/.dwm/reflashBar.sh
    sleep 3 
done &

while true; do
  ~/.dwm/random_wallpaper.sh
  sleep 180
done &
