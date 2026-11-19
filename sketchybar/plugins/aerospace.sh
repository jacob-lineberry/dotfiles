#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color=0xff7aa2f7 \
    label.color=0xff1d202f
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    label.color=0xffc0caf5
fi
