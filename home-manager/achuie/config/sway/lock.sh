#!/usr/bin/env bash

MAGICK=$(command -v magick) || exit 1
LOCK=$(command -v swaylock) || exit 2
NOTIFY=$(command -v notify-send) || exit 3
RG=$(command -v rg) || exit 4
SED=$(command -v sed) || exit 5
BC=$(command -v bc) || exit 6
JQ=$(command -v jq) || exit 7
SWAYMSG=$(command -v swaymsg) || exit 8

lockbg="${HOME}/.lockscreen.png"
if [ ! -e "$lockbg" ] || [ "$1" == "-r" ]; then
  $NOTIFY -u low -a lockscreen "Generating lockscreen image from background"

  wall="${HOME}/.background-image"
  $MAGICK "$wall" -resize 2256x2256 "$lockbg"

  rawdimensions=$(identify "$lockbg" | $RG PNG | \
    $SED -n 's/.*[^0-9]\([0-9]\+x[0-9]\+\).*/\1/p')
  # Parse "<x-dimension>x<y-dimension>"
  IFS='x' read -ra dimensions <<< "$rawdimensions"

  rectX=$($BC <<<"${dimensions[0]}*38/1000")
  rectY=$($BC <<<"${dimensions[1]}*736/1000")
  rectWidth=$($BC <<<"${dimensions[0]}*270/1000")
  rectHeight=$($BC <<<"${dimensions[1]}*136/1000")

  $MAGICK "${HOME}/.lockscreen.png" -fill "#32344abb" \
    -draw "rectangle ${rectX},${rectY},$(($rectX+$rectWidth)),$(($rectY+$rectHeight))" \
    -region "${rectWidth}x${rectHeight}+${rectX}+${rectY}" \
    -blur 0x8 "${HOME}/.lockscreen.png"
fi

dimensions=($($SWAYMSG -t get_outputs | $JQ '.[0] | .rect | .width, .height'))
indXPos=$($BC <<<"${dimensions[0]}*253/1000")
indYPos=$($BC <<<"${dimensions[1]}*868/1000")
$LOCK --ignore-empty-password \
  --indicator-radius 60 --indicator \
  --indicator-x-position=$indXPos --indicator-y-position=$indYPos \
  --inside-color=00000088 \
  --inside-color=32344a88 --ring-color=ffffffff --line-uses-ring \
  --key-hl-color=7aa2f7ff --bs-hl-color=444b6aff --separator-color=00000000 \
  --ring-ver-color=75c1eeff --inside-ver-color=7dcfff88 \
  --ring-wrong-color=ea4e6bff --inside-wrong-color=ff426688 \
  --text-ver="..." --text-wrong="!" --text-clear="---" \
  --text-ver-color=ffffffff --text-wrong-color=ffffffff \
  --font="Fira Code Custom" \
  --timestr="%H:%M" --datestr="%a %Y-%m-%d" \
  --text-color=ffffffff \
  --clock --timestr="%H:%M" --datestr="%a %Y-%m-%d" \
  -i "${HOME}/.lockscreen.png" --scaling="fill"
  # --time-align 1 --date-align 1 \
  # --force-clock --time-pos="ix-510:iy+20" --date-pos="ix-503:ty+60" \
  # --time-color=ffffffff --time-size=135 --timestr="%H:%M" \
  # --date-color=ffffffff --date-size=45 --datestr="%a %Y-%m-%d" \
