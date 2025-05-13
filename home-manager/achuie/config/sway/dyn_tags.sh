#!/usr/bin/env bash

# Focus a workspace or create a new one.

SWAYMSG=$(command -v swaymsg) || exit 1
JQ=$(command -v jq) || exit 2

$SWAYMSG workspace $($SWAYMSG -t get_workspaces | $JQ -M '.[] | .name' \
    | tr -d '"' | sort -u | wmenu -f "FiraCodeCustom 8")
