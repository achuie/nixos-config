#!/usr/bin/env bash

# Move a window to an existing or new workspace.

SWAYMSG=$(command -v swaymsg) || exit 1
JQ=$(command -v jq) || exit 2

$SWAYMSG -t command move workspace $($SWAYMSG -t get_workspaces \
    | $JQ -M '.[] | .name' | tr -d '"' | sort -u | wmenu -f "FiraCodeCustom 8")
