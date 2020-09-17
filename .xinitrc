# if wallpapers directory exits -> set a random wallpaper
[ -d ~/Pictures/wallpapers ] && feh --bg-fill --randomize ~/Pictures/wallpapers

# start compton and conky
compton &
conky -c .config/conky/conky.conf -d

# execute i3wm
exec i3
