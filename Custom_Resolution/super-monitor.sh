#!/bin/bash
# Peter Senna Tschudin - peter.senna@gmail.com
#

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
