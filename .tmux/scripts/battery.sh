#!/bin/sh
pct=""
chg=0
if command -v pmset >/dev/null 2>&1; then
  out=$(pmset -g batt 2>/dev/null)
  pct=$(printf '%s' "$out" | grep -Eo '[0-9]+%' | head -n1 | tr -d %)
  if ! printf '%s' "$out" | grep -q 'discharging'; then chg=1; fi
elif [ -r /sys/class/power_supply/BAT0/capacity ]; then
  pct=$(cat /sys/class/power_supply/BAT0/capacity)
  [ "$(cat /sys/class/power_supply/BAT0/status)" != "Discharging" ] && chg=1
fi
[ -z "$pct" ] && exit 0

if [ "$pct" -le 15 ]; then
  col="#f38ba8"
elif [ "$pct" -le 30 ]; then
  col="#f9e2af"
else col="#a6e3a1"; fi

if [ "$chg" = 1 ]; then
  icon="󰂄"
  col="#94e2d5"
else
  i=$((pct / 10))
  [ "$i" -gt 10 ] && i=10
  case "$i" in
  0 | 1) icon="󰁺" ;; 2) icon="󰁻" ;; 3) icon="󰁼" ;; 4) icon="󰁽" ;;
  5) icon="󰁾" ;; 6) icon="󰁿" ;; 7) icon="󰂀" ;; 8) icon="󰂁" ;;
  9) icon="󰂂" ;; *) icon="󰁹" ;;
  esac
fi

printf '#[fg=%s]#[bg=%s,fg=#1e1e2e]%s #[bg=#313244,fg=#cdd6f4] %s%% #[bg=#1e1e2e,fg=#313244] ' "$col" "$col" "$icon" "$pct"
