# if wallpapers directory exits -> set a random wallpaper
[ -d ~/Pictures/wallpapers ] && command -v feh &> /dev/null \
    feh --bg-fill --randomize ~/Pictures/wallpapers

# start compton and conky
compton --opacity-rule '90:class_g = "URxvt" && !focused' &
conky -c .config/conky/conky.conf -d

# turn off beeps
xset b off

# execute i3wm
exec i3
