#!/bin/bash
clear

PARAM_COUNT=${#}      #Count all parametrs
PARAM_PART=6          #Count parametrs from part

if [ -n "$1" ]
  then
    if [ $PARAM_COUNT -eq $PARAM_PART ]
      then
        PATH_ABSOLUTE=$1              #Parameter 1 is the absolute path
        NUM_OF_SUBFOLDERS=$2          #Parameter 2 is the number of subfolders
        LIST_LETTERS_FOLDER=$3        #Parameter 3 is a list of English alphabet letters used in folder names (no more than 7 characters).
        NUM_OF_FILES_IN_FOLDER=$4     #Parameter 4 is the number of files in each created folder.
        LIST_LETTERS_FILE_AND_EXT=$5  #Parameter 5 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).
        FILE_SIZE_KB=$6               #Parameter 6 - file size (in kilobytes, but not more than 100).

        ./check_args.sh $PATH_ABSOLUTE $NUM_OF_SUBFOLDERS $LIST_LETTERS_FOLDER $NUM_OF_FILES_IN_FOLDER $LIST_LETTERS_FILE_AND_EXT $FILE_SIZE_KB
        if [ $? -eq 0 ] 
          then
            ./file_generator.sh $PATH_ABSOLUTE $NUM_OF_SUBFOLDERS $LIST_LETTERS_FOLDER $NUM_OF_FILES_IN_FOLDER $LIST_LETTERS_FILE_AND_EXT $FILE_SIZE_KB
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


