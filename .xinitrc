xset b off
dbus-update-activation-environment --systemd DISPLAY

# if wallpapers directory exits -> set a random wallpaper
[ -d ~/Pictures/wallpapers ] && command -v nitrogen &> /dev/null \
    nitrogen --set-zoom-fill --random ~/Pictures/wallpapers

# start dunst (desktop notifications) and conky (desktop tray)
#command -v dunst &> /dev/null && dunst &
#command -v conky &> /dev/null && conky -c .config/conky/conky.conf -d
command -v eww &> /dev/null && eww daemon && eww open bar

# execute bspwm
exec bspwm
