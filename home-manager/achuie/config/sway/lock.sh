#!/usr/bin/env bash

revert() {
  xset dpms 0 0 0
  xset -dpms
}

trap revert HUP INT TERM
xset +dpms dpms 15 15 15

if [ ! -e "${HOME}/.lockscreen.png" ] || [ "$1" == "-r" ]; then
  wall="$(tail -n 1 ${HOME}/.fehbg | sed "s/[^']*'//" | sed "s/'//")"

  rectX=85
  rectY=1220
  rectWidth=610
  rectHeight=200

  convert "$wall" -resize 2256x2256 -fill "#32344abb" \
    -draw "rectangle ${rectX},${rectY},$(($rectX+$rectWidth)),$(($rectY+$rectHeight))" \
    -region "${rectWidth}x${rectHeight}+${rectX}+${rectY}" \
    -blur 0x8 "${HOME}/.lockscreen.png"
fi

i3lock --nofork --ignore-empty-password \
  --radius 60 --ring-width 15 --indicator --ind-pos="608:y+h-185" \
  --color=00000088 \
  --inside-color=32344a88 --ring-color=ffffffff --line-uses-ring \
  --keyhl-color=7aa2f7ff --bshl-color=444b6aff --separator-color=00000000 \
  --ringver-color=75c1eeff --insidever-color=7dcfff88 \
  --ringwrong-color=ea4e6bff --insidewrong-color=ff426688 \
  --verif-text="..." --wrong-text="!" --noinput-text="---" \
  --verif-color=ffffffff --wrong-color=ffffffff \
  --time-font="Fira Code" --date-font="Fira Code" --layout-font="Fira Code" \
  --time-align 1 --date-align 1 \
  --force-clock --time-pos="ix-510:iy+20" --date-pos="ix-503:ty+60" \
  --time-color=ffffffff --time-size=135 --time-str="%H:%M" \
  --date-color=ffffffff --date-size=45 --date-str="%a %Y-%m-%d" \
  -i "${HOME}/.lockscreen.png"

revert
