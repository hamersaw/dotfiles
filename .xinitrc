# if wallpapers directory exits -> set a random wallpaper
[ -d ~/pictures/wallpapers ] && command -v nitrogen &> /dev/null \
    nitrogen --set-zoom-fill --random ~/pictures/wallpapers

# start compton and conky
#compton --opacity-rule '90:class_g = "URxvt" && !focused' &
#compton &
conky -c .config/conky/conky.conf -d

# turn off beeps
xset b off

# execute i3wm
#exec i3

# execute bspwm
exec bspwm
