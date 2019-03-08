[ -d ~/Pictures/wallpapers ] && feh --bg-fill --randomize ~/Pictures/wallpapers
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
compton &
conky -c .config/conky/conky.conf -d

xset b off
exec bspwm
