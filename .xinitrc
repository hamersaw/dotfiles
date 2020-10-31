# if wallpapers directory exits -> set a random wallpaper
[ -d ~/pictures/wallpapers ] && command -v nitrogen &> /dev/null \
    nitrogen --set-zoom-fill --random ~/pictures/wallpapers

# start compton and conky
#compton --opacity-rule '90:class_g = "URxvt" && !focused' &
#conky -c .config/conky/conky.conf -d

# start polybar
command -v polybar &> /dev/null \
    polybar core > /dev/null 2>&1 & disown

# turn off beeps
xset b off

# execute i3wm
#exec i3

# execute bspwm
exec bspwm
