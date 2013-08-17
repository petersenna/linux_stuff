#!/bin/bash
# Peter Senna Tschudin - peter.senna@gmail.com
#
# Please note that there is no warranty that this script works for you, and
# there is no warranty that this script is safe for your hardware. I'm quite
# sure that playing with Modelines can burn some old CRT monitors. I've never
# heard that you can burn LCD / LED monitors, but I'm not sure.

# Monitor information
H=2560
V=1440
Hz=38

# Video output. Run xrandr to get the propper string
OUTPUT=HDMI3

# Choose the tool to calculate the modeline
#TOOL=gtf # Generalized Timing Formula 1999 standard
TOOL=cvt # Coordinated Video Timings VESA-2003-9

# grep -oP returns the string that starts with Modeline.
# This enables extracting the output of both tools
# without changing the -f paramenter of cut.
MODELINE=$($TOOL $H $V $Hz|grep -oP "Modeline.*"|cut -d " " -f 2-)

NAME=$(echo $MODELINE|cut -d " " -f 1)
xrandr --newmode $MODELINE
xrandr --addmode $OUTPUT $NAME
xrandr --output $OUTPUT --mode $NAME

#This do not change anything, only shows what is being used
xrandr

echo Some times it is necessary to run the script twice...
