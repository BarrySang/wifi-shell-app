#!/bin/bash

# store status of wifi device in wifi_status variable
wifi_status=$(nmcli radio wifi)

# display wifi device status to user using zenity
if [ "$wifi_status" = "enabled" ]
then
    zenity --question --width=200 --height=200 --title="Wi-Fi Device Status" --text="Status: $wifi_status \n \n Would you like to turn the wifi device on?" --no-wrap
fi

# turn on wifi device if user input is "yes"
if [ "$?" = "0" ]
then
    # use 'nmcli' to turn wifi device on
    # nmcli radio wifi on

    # get the available network interfaces and store them in a txt file
    ip link show | awk -F': ' '/^[0-9]+:/{print $2}' > network_interfaces_list.txt

    # create an empty array to store the names of the available network interfaces
    network_interfaces=()
    while IFS= read -r line; do
        network_interfaces+=("$line")
    done < "network_interfaces_list.txt"

    # show the names of the network interfaces as a selectable list
    selected_interface=$(zenity --list --title "Select a Network Interface" --column "Network Interfaces" "${network_interfaces[@]}")

    # get and store the names and signal strengths of the available wifi networks
    nmcli --terse --fields ssid,signal dev wifi list ifname $selected_interface > available_networks_list.txt

    # declare array to store available networks in
    available_networks=()
    while IFS= read -r line; do
        result=$(echo "$line" | rev | awk -F: '{print substr($0, index($0,$2))}' | rev)
        # echo "$result"
        available_networks+=("$result")
    done < "available_networks_list.txt"

    # show the names and signal strengths of the available wifi networks
    selected_network=$(zenity --list --title "Select a Network" --column "Available Networks" "${available_networks[@]}")
fi