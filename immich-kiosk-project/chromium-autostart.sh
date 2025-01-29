#!/bin/dash
# Autostart script for kiosk mode, based on @AYapejian: https://github.com/MichaIng/DietPi/issues/1737#issue-318697621

# Resolution to use for kiosk mode, should ideally match current system resolution
RES_X=$(sed -n '/^[[:blank:]]*SOFTWARE_CHROMIUM_RES_X=/{s/^[^=]*=//p;q}' /boot/dietpi.txt)
RES_Y=$(sed -n '/^[[:blank:]]*SOFTWARE_CHROMIUM_RES_Y=/{s/^[^=]*=//p;q}' /boot/dietpi.txt)

# Command line switches: https://peter.sh/experiments/chromium-command-line-switches/
# - Review and add custom flags in: /etc/chromium.d
CHROMIUM_OPTS="--kiosk --no-memcheck --window-size=${RES_X:-1280},${RES_Y:-800} --window-position=0,0"

# If you want tablet mode, uncomment the next line.
#CHROMIUM_OPTS="$CHROMIUM_OPTS --force-tablet-mode --tablet-ui"

# Home page
URL=$(sed -n '/^[[:blank:]]*SOFTWARE_CHROMIUM_AUTOSTART_URL=/{s/^[^=]*=//p;q}' /boot/dietpi.txt)

# RPi or Debian Chromium package
FP_CHROMIUM=$(command -v chromium-browser)
[ "$FP_CHROMIUM" ] || FP_CHROMIUM=$(command -v chromium)

# Use "startx" as non-root user to get required permissions via systemd-logind
STARTX='xinit'
[ "$USER" = 'root' ] || STARTX='startx'

exec "$STARTX" "$FP_CHROMIUM" $CHROMIUM_OPTS "${URL:-http://localhost:3000}"
