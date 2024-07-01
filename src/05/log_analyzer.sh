#!/bin/bash

MENU_ITEM=$1
LOG_FILES="$(pwd)/../04/*.log"

CHECK_LOG=`ls -l $(pwd)/../04/*.* | grep '\.log'`

if [ "$CHECK_LOG" = "" ] 
then
  echo "Logfile not found! Go to directory \"04\" and run \"./main.sh\""
else
    case "$MENU_ITEM" in
        1)  clear
            cat $LOG_FILES | awk '{print $9, $0}' | sort -n | cut -d ' ' -f2-
            ;;
        2)  clear
            cat $LOG_FILES | awk '{print $1}' | sort -u | sort -n
            ;;
        3)  clear
            cat $LOG_FILES | awk '($9 >= 400 && $9 < 600) {print}'
            ;;
        4)  clear
            cat $LOG_FILES | awk '($9 >= 400 && $9 < 600) {print}' | awk '{print $1}' | sort -u | sort -n
            ;;
    esac

fi