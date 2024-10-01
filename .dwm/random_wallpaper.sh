#!/bin/bash

wallpaper_dir="$HOME/Pictures/wallpaper"
random=$(find "$wallpaper_dir" -type f | shuf -n 1)

feh --bg-fill "$random"
