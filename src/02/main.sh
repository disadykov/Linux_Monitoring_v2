#!/bin/bash
clear

PARAM_COUNT=${#}      #Count all parametrs
PARAM_PART=3          #Count parametrs from part
START_SCRIPT=`date +'%Y-%m-%d %H:%M:%S'`
start_time=`date +%s%N`

if [ -n "$1" ]
  then
    if [ $PARAM_COUNT -eq $PARAM_PART ]
      then
        LIST_LETTERS_FOLDER=$1        #Parameter 1 is a list of English alphabet letters used in folder names (no more than 7 characters).
        LIST_LETTERS_FILE_AND_EXT=$2  #Parameter 2 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).
        FILE_SIZE_MB=$3               #Parameter 3 - file size (in kilobytes, but not more than 100).

        ./check_args.sh $LIST_LETTERS_FOLDER $LIST_LETTERS_FILE_AND_EXT $FILE_SIZE_MB
        if [ $? -eq 0 ] 
          then
            ./file_generator.sh $LIST_LETTERS_FOLDER $LIST_LETTERS_FILE_AND_EXT $FILE_SIZE_MB "$START_SCRIPT" $start_time
          else
            echo "One or more parameters are invalid or have warning. Try again with the correct set of parameters."
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


