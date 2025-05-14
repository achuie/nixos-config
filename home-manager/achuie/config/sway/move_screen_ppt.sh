#!/usr/bin/env bash

# Gets the pixel coordinates of the given percentage of screen width and
# height, from the top left corner.

SWAYMSG=$(command -v swaymsg) || exit 1
JQ=$(command -v jq) || exit 2

ACTIVE=$($SWAYMSG -t get_workspaces | $JQ -M '.[] | {f: .focused, out: .output}
    | select(.f == true) | .out')

$SWAYMSG -t command move position $($SWAYMSG -t get_outputs \
    | $JQ -M '.[] | {out: .name, r: .rect} | select(.out == '"$ACTIVE"')
    | [.r.width, .r.height, .r.x, .r.y]
    | [.[0]*.'"$1"'+.[2], .[1]*.'"$2"'+.[3]]
    | map(floor) | join(" ")' | tr -d '"')
