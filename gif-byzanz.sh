#!/bin/bash
 
# AUTHOR:   (c) Rob W 2012
#           modified by MHC (http://askubuntu.com/users/81372/mhc)
#           and by Rodolfo Carvalho
# ALSO FRM: RobinJ1995: https://github.com/RobinJ1995/gifrecord
#           Mixed together randomly by: prenex (Thier Richard)
# NAME:     GIFRecord 2
# DESCRIPTION:  A script to record GIF screencasts.
# LICENSE:  GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)
# DEPENDENCIES:   byzanz,zenity,notify-send, xrectsel

set -e

# Time and date
TIME=$(date +"%Y-%m-%d_%H%M%S")
 
# Delay before starting
DELAY=10
 
# Standard screencast folder
FOLDER=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
 
# Default recording duration
DEFDUR=10
 
# Sound notification to let one know when recording is about to start (and ends)
beep() {
    paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga &
}
 
# Custom recording duration as set by user
USERDUR=$(zenity --entry --title "Recoding duration" --text "Please enter the screencast duration in seconds:" --width 200 --height 100 2>/dev/null)
 
# Duration and output file
if [ $USERDUR -gt 0 ]; then
    D=$USERDUR
else
    D=$DEFDUR
fi
 
# Notify the user of recording time and delay
notify-send "GIFRecorder" "Recording duration set to $D seconds. Recording will start in $DELAY seconds. Open things if needed!"
 
#Actual recording
sleep $DELAY
beep

area=`xrectsel`

size=`echo $area | cut -f1 -d+`
coords=`echo $area | cut -f2- -d+`

W=`echo $size | cut -f1 -dx`
H=`echo $size | cut -f2 -dx`

X=`echo $coords | cut -f1 -d+`
Y=`echo $coords | cut -f2 -d+`
byzanz-record -c --verbose --delay=0 --duration=$D --x=$X --y=$Y --width=$W --height=$H "$FOLDER/GIFrecord_$TIME.gif"
beep
 
# Notify the user of end of recording.
notify-send "GIFRecorder" "Screencast saved to $FOLDER/GIFrecord_$TIME.gif"
