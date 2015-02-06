#!/bin/bash

# Commands required by this script
declare -x awk="/usr/bin/awk"
declare -x sysctl="/usr/sbin/sysctl"
declare -x perl="/usr/bin/perl"

declare -xi DAY=86400
declare -xi EPOCH="$($perl -e "print time")"
declare -xi UPTIME="$($sysctl kern.boottime |
                        $awk -F'[= ,]' '/sec/{print $6;exit}')"

declare -xi DIFF="$(($EPOCH - $UPTIME))"

if [ $DIFF -le $DAY ] ; then
        echo "<result>1</result>"
else
        echo "<result>$(($DIFF / $DAY))</result>"
fi

#Evernote Logo installed by a dmg within the policy.
LOGO="/private/tmp/Evernote.icns"

PROMPT_TITLE="Evernote IT - Restart Reminder for longer uptimes"
PROMPT_HEADING="Please Restart your Mac!                  " 
PROMPT_DESCRIPTION="Your Mac has been awake for `echo $(($DIFF / $DAY))` days.

For optimal performance please reboot your machine :) "

#Display Evernote branded prompt with reboot reminder.
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -lockHUD -icon "$LOGO" -title "$PROMPT_TITLE" -heading "$PROMPT_HEADING" -description "$PROMPT_DESCRIPTION" -button1 "OK" -defaultButton 1