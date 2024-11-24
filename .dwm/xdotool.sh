#!/bin/bash

while true; do
    xdotool mousemove_relative 1 0
    sleep 300
    xdotool mousemove_relative -- -1 0
    sleep 300
done &
