[ -d ~/Pictures/wallpapers ] && feh --bg-fill --randomize ~/Pictures/wallpapers
compton &
conky -c .config/conky/conky.conf -d

xset b off
exec bspwm
