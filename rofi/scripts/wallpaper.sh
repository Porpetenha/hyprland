#!/usr/bin/env bash

IMG_DIR="$HOME/Imagens/wallpaper"

config_file="$HOME/.config/hypr/hyprpaper.conf"

theme="$HOME/.config/rofi/scripts/wallpaper.rasi"

[ -d "$IMG_DIR" ] || { echo "Diretório não encontrado: $IMG_DIR"; exit 1; }

# Junta arquivos numa array preservando espaços/bytes especiais (usa -print0)
mapfile -d $'\0' -t files < <(find "$IMG_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) -print0)

if [ "${#files[@]}" -eq 0 ]; then
  echo "Nenhuma imagem encontrada."
  exit 0
fi

# Cria array de nomes (basenames) para mostrar no rofi
names=()
for f in "${files[@]}"; do
  names+=("$(basename "$f")")
done

# Mostra nomes + thumbnail no rofi
choice=$(for f in "${files[@]}"; do
  name="$(basename "$f")"
  printf "%s\0icon\x1fthumbnail://%s\n" "$name" "$f"
done | rofi -dmenu -show-icons -p "Escolha uma imagem:" -lines 10 -theme ${theme})


[ -z "$choice" ] && exit 0

# Acha o índice do escolhido e retorna o path correspondente
selected_file=""
for i in "${!names[@]}"; do
  if [ "${names[$i]}" = "$choice" ]; then
    selected_file="${files[$i]}"
    break
  fi
done

# Atualiza o hyprpaper.conf apenas com o novo arquivo
sed -i "s|^\(preload = \).*|\1$selected_file|" "$config_file"
sed -i "s|^\(wallpaper = , \).*|\1$selected_file|" "$config_file"

killall hyprpaper
hyprpaper &

notify-send "Wallpaper alterado" "Alterado para $choice"