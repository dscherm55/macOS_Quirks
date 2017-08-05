#!/bin/sh

echo "\n================================================================================\n"
echo " (!) This script contains commands to disable or enable the following options:"
echo "     1.) Apps From Anywhere."
echo "     2.) Hibernate Mode. (Macbook, Macbook Pro, Hackinotsh Laptop)"
echo "     3.) Check Hibernate, Auto Poweroff, and Stand By modes."
echo "     4.) Dock Open Delay."
echo "     5.) Show File Path in Finders Title Bar."
echo " (!) Script uses Super User permissions, use at your own risk."
echo "\n================================================================================\n"

read -r -p "---> Would you like to cutomize features on the OS? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    continue
else
    echo "\n================================================================================\n"
    echo " (i) Not sure why you started the script. Either way, see ya later, Homie.\n"
    exit
fi

# Ask user if they would like app from anywhere fixed
echo "\n================================================================================\n"
echo " (i) Starting customize OS"
echo "\n================================================================================\n"
echo "\t  No = Will disable apps from anywhere."
echo "\t Yes = Will enable apps from anywhere to open without error.\n"

read -r -p "---> Would you like to enable apps from anywhere? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo # Blank line
    sudo spctl --master-disable
    echo "\n (i) Apps From Anywhere is enabled. :) :) :)"
    echo "\n================================================================================\n"
    sleep 2
else
    sudo spctl --master-enable
    echo "\n (i) App From Anywhere is disabled; Prepare to be annoyed. :("
    echo "\n================================================================================\n"
    continue
fi

# Disable Hibernate
echo " (!) It is not necessary to touch hibernate on an iMac only Macbooks, Hackintosh"
echo "     laptops, or Macbook Pros. Select No twice to skip."
echo "\t  No = Will allow you to turn Hibernate on or skip the step completely."
echo "\t Yes = Will turn Hibernate off.\n"

read -r -p "---> Would you like to disable Hibernate? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    sudo pmset -a hibernatemode 0
    sudo pmset -a autopoweroff 0
    sudo pmset -a standby 0
    sudo rm /private/var/vm/sleepimage
    sudo touch /private/var/vm/sleepimage
    sudo chflags uchg /private/var/vm/sleepimage
    echo "\n (i) Hibernate is disabled. This maybe necessary to do again after OS updates."
    echo "\n================================================================================\n"
else
    read -r -p "---> Would you like to enable Hibernate? <--- " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        sudo pmset -a hibernatemode 3
        sudo pmset -a autopoweroff 1
        sudo pmset -a standby 1
        echo "\n (i) Hibernate is Enabled."
        echo "\n================================================================================\n"
    else
        echo "\n (i) Settings were left as is."
        echo "\n================================================================================\n"
        continue
    fi
fi

# Check sleep status.
echo "\t  No = The action will be skipped."
echo "\t Yes = Hibernate status will be displayed below.\n"

read -r -p "---> Would you like to check Hibernate status? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo # Blank line
    sudo pmset -g custom | grep "hibernatemode \|standby \|autopoweroff "
    echo "\n================================================================================\n"
    sleep 5
else
    echo "\n (i) Skipped."
    echo "\n================================================================================\n"
    continue
fi

# Disable dock open delay
echo "\t  No = Enables Dock Open delay and sets to default."
echo "\t Yes = Removes Dock Open delay. Sets to 0.\n"

read -r -p "---> Would you like to disable Dock opening delay? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo # Blank line
    defaults write com.apple.Dock autohide-delay -float 0 && killall Dock
    echo "\n (i) Autohide delays have been removed from the Dock."
    echo "\n================================================================================\n"
    sleep 3
else
    defaults delete com.apple.Dock autohide-delay && killall Dock
    echo "\n (i) Dock open delay has been set to default."
    echo "\n================================================================================\n"
    continue
fi

# Show File path in Finder
echo "\t  No = This will remove folder path in Finder and set to default."
echo "\t Yes = This will turn on folder path in Finder.\n"

read -r -p "---> Would you like to show the folder path in the Title of Finder windows? <--- " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder
    echo "\n (i) Full file path will now show in Finder Title."
    echo "\n================================================================================\n"
else
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool false; killall Finder
    echo "\n (i) Full file path is removed from Finder Title."
    echo "\n================================================================================\n"
    continue
fi

exit
