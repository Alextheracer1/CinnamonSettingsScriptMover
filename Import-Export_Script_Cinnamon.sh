#!/bin/bash

currentDesktop=$XDG_CURRENT_DESKTOP
cinnamonDconfPath="."
cinnamonLocalFolderPath="."


importSettings() {

dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --msgbox "\nIn the next few steps I'm going to guide you through the import proccess. Make sure you have your cinnamon.dconf file ready. \nIf you don't have one, create one with 'dconf dump /org/cinnamon/ > cinnamon.dconf'" 10 60

dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --yesno "\nAre your .dconf files in the same folder as the script?" 8 50
answerDconf=${?}

if [ "$answerDconf" -eq "1" ]
then
    cinnamonDconfPath=$(dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --inputbox "Enter the path here \n(do not add '/' after the last directory)" 8 40 --output-fd 1)
    
fi

if [ "${?}" -eq "255" ]
then
    clear
    exit 255
fi


dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --yesno "\nDid you copy the '~/.local/share/cinnamon' Folder from the old machine?" 8 50
answerCopyFolder=${?}

if [ "$answerCopyFolder" -eq "0" ]
then
    dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --yesno "\nIs this folder in the same one as the script?" 8 50
    answerFolderLocation=${?}


if [ "$answerFolderLocation" -eq "1" ]
then
    cinnamonLocalFolderPath=$(dialog --backtitle "Cinnamon Theme Script" --title "Import Settings and Applets" --inputbox "Enter the path here \n(do not add '/' after the last directory)" 8 40 --output-fd 1)
fi

fi

dialog --backtitle "Cinnamon Theme Script" --infobox "Importing Settings..." 3 40


if [ "$answerCopyFolder" -eq "0" ]
then
cp -vr $cinnamonLocalFolderPath/.local ~
fi

dconf load /org/cinnamon/ < $cinnamonDconfPath/cinnamon.dconf
dconf load /org/gtk/ < $cinnamonDconfPath/gtk.dconf

sleep 2

dialog --pause "Settings successfully imported!" 10 50 10
clear

}

exportSettings() {

dialog --backtitle "Cinnamon Theme Script" --title "Export Settings and Applets" --msgbox "\nThe settings will be exported to the same folder as the script is in." 10 50

dialog --backtitle "Cinnamon Theme Script" --infobox "Exporting Settings..." 3 40

mkdir export
cd export


dconf dump /org/cinnamon/ > cinnamon.dconf
dconf dump /org/gtk/ > gtk.dconf
mkdir -p .local/share/cinnamon

cp -r ~/.local/share/cinnamon .local/share/cinnamon

sleep 2


dialog --pause "Settings successfully exported! To show the '.local' folder, type 'ls -a' in a terminal or press 'Ctrl + H' on the keyboard in your file browser" 15 50 10

clear
}




dialog --backtitle "Cinnamon Theme Script"  --msgbox "This is a script to import / export Cinnamon theme settings and installed Applets. \n\n\nUse at your own risk!" 10 50

dialog --backtitle "Cinnamon Theme Script" --infobox "Checking for compatibility..." 3 40
sleep 2

# Change to CINNAMON later
if [[ $currentDesktop == "X-Cinnamon" ]]; then

     # Do stuff
     dialog --backtitle "Cinnamon Theme Script"  --infobox "Supported system found!" 3 40
     sleep 1

     antwort=$(dialog --backtitle "Cinnamon Theme Script" --menu "Choose what you want to do" 10 45 25 1 "Import Settings and Applets" 2 "Export Settings and Applets" --output-fd 1)


     if [[ $antwort == 1 ]]; then 

        importSettings

     fi

     if [[ $antwort == 2 ]]; then 

        exportSettings

     fi

     #dconf load /org/cinnamon/ < cinnamon.dconf
     

     

else
     #echo "Not a supported system. This script is for use with CINNAMON only! Exiting...."
     dialog --pause "Not a supported system! \nThis script is for use with CINNAMON only!" 10 50 10
     clear
     exit
fi

clear
