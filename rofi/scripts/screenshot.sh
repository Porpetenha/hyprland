#!/bin/bash

theme="$HOME/.config/rofi/scripts/powermenu.rasi"

region="Região"
region_s="Região - Pasta"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-mesg "Selecione a opção" \
		-theme ${theme}
}

selected_option=$(echo "" | rofi_cmd)

if [ "$selected_option" == "$lock" ]
then
  hyprlock
elif [ "$selected_option" == "$logout" ]
then
  hyprctl dispatch exit
else
  echo "No match"
fi