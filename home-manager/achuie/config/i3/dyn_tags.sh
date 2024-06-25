#!/usr/bin/env bash

# Focus a workspace or create a new one.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

$I3MSG workspace $($I3MSG -t get_workspaces | $JQ -M '.[] | .name' \
    | tr -d '"' | sort -u | dmenu --font "Fira Code Custom")
