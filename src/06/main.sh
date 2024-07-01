#!/bin/bash
clear

if [ -n "$1" ]
  then
      echo "The script: [$0] must be run without parmaters. Try again!"
  else

    LOG_FILES="$(pwd)/../04/*.log"
    CHECK_LOG=`ls -l $(pwd)/../04/*.* | grep '\.log'`

    if [ "$CHECK_LOG" = "" ] 
    then
      echo "Logfile not found! Go to directory \"04\" and run \"./main.sh\""
    else
      #install
      ./install.sh
      
      goaccess -a --log-format=COMBINED -f $LOG_FILES 
      goaccess $(pwd)/../04/*.log --log-format=COMBINED -o report.html
    fi
fi


