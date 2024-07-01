#!/bin/bash
clear

PARAM_COUNT=${#}      #Count all parametrs
PARAM_PART=1          #Count parametrs from part

if [ -n "$1" ]
  then
    if [ $PARAM_COUNT -eq $PARAM_PART ]
      then
        MENU_ITEM=$1              #Parameter 1. Menu item
        ./check_args.sh $MENU_ITEM
        if [ $? -eq 0 ] 
          then
            ./log_analyzer.sh $MENU_ITEM
          else
            echo "Parameter are invalid. Try again with the correct set of parameters."
            echo "Usage: $0 <option>"
            echo "Options:"
            echo "        1 - All entries sorted by response code"
            echo "        2 - All unique IPs found in the entries"
            echo "        3 - All requests with errors (response code - 4xx or 5xx)"
            echo "        4 - All unique IPs found among the erroneous requests"
        fi
      else
        if [ $PARAM_COUNT -gt $PARAM_PART ]
          then
            msg="many"
          else
            msg="few"
        fi
        echo "Too $msg parameters. Try again with $PARAM_PART parameters."
    fi
  else
    echo "No parameters found! Please usage $0 with $PARAM_PART parameters."
    exit 1
fi
