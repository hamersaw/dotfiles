# if wallpapers directory exits -> set a random wallpaper
[ -d ~/pictures/wallpapers ] && command -v nitrogen &> /dev/null \
    nitrogen --set-zoom-fill --random ~/pictures/wallpapers

# start dunst (desktop notifications) and conky (desktop tray)
command -v dunst &> /dev/null && dunst &
command -v conky &> /dev/null && conky -c .config/conky/conky.conf -d

# execute bspwm
exec bspwm
