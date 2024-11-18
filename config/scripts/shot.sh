#!/bin/bash

# Cattura lo screenshot
SCREENSHOT="/tmp/screen.png"
grim "$SCREENSHOT"

# Applica il blur
convert "$SCREENSHOT" -blur 8x4 -brightness-contrast -18x-5 "$SCREENSHOT"
