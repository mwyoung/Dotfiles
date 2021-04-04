#!/bin/bash

#LOCATION="sudo tee /sys/bus/serio/devices/serio1/drvctl"

#echo -n "none" > $LOCATION
#echo -n "reconnect" > $LOCATION

trackbuttons="$(xinput list | grep TrackPoint | cut -f 2 | cut -d '=' -f 2)"
if [[ ! -z "$trackbuttons" ]]; then
    eval xinput --set-prop $trackbuttons \'libinput Accel Speed\' -0.5
else
    echo "Error - could not find Trackpoint"
fi
trackpad="$(xinput list | grep Synaptics | cut -f 2 | cut -d '=' -f 2)"
if [[ ! -z "$trackpad" ]]; then
    eval xinput --set-prop $trackpad \'libinput Tapping Enabled\' 1
    eval xinput --set-prop $trackpad \'libinput Accel Speed\' .1
else
    echo "Error - could not find Trackpad"
fi

#displayID=$(xinput list --id-only 'Synaptics TM3053-003')
#xinput set-prop $displayID "libinput Tapping Enabled" 1
#xinput set-prop $displayID "libinput Accel Speed" .1
