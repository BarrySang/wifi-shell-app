#!/bin/bash

# store status of wifi device in wifi_status variable
wifi_status=$(nmcli radio wifi)

# display wifi device status to user using zenity
if [ "$wifi_status" = "disabled" ]
then
    zenity --question --width=200 --height=200 --title="Wi-Fi Device Status" --text="Status: $wifi_status \n \n Would you like to turn the wifi device on?" --no-wrap
fi

# turn on wifi device if user input is "yes"
if [ "$?" = "0" ]
then
    # use 'nmcli' to turn wifi device on
    nmcli radio wifi on

    # scan for available wifi networks
    available_networks=$(nmcli dev wifi list)
    echo $available_networks
fi