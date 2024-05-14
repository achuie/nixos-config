#!/bin/bash

# Move a window to an existing or new workspace.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

$I3MSG -t command move workspace $($I3MSG -t get_workspaces \
    | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu --font "Fira Code")
