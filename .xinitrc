[ -d ~/Pictures/wallpapers ] && feh --bg-fill --randomize ~/Pictures/wallpapers
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

xset b off
exec bspwm
