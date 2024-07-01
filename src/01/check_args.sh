#!/bin/bash

PATH_ABSOLUTE=$1              #Parameter 1 is the absolute path
NUM_OF_SUBFOLDERS=$2          #Parameter 2 is the number of subfolders
LIST_LETTERS_FOLDER=$3        #Parameter 3 is a list of English alphabet letters used in folder names (no more than 7 characters).
NUM_OF_FILES_IN_FOLDER=$4     #Parameter 4 is the number of files in each created folder.
LIST_LETTERS_FILE_AND_EXT=$5  #Parameter 5 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).
FILE_SIZE_KB=$6               #Parameter 6 - file size (in kilobytes, but not more than 100).

ERR_FLAG=0                    #No errors

#check PATH_ABSOLUTE
GENERAT_TMP_DIR=`date '+%S_%d_%m_%S_%y_%H_%S-%d_%m_%y_%H_%S_%d_%m'`
GENERAT_TMP_DIR1=`head -c4 /dev/urandom | od -N4 -tu4 | sed -ne '1s/.* //p'`
GENERAT_TMP_DIR=$GENERAT_TMP_DIR1$GENERAT_TMP_DIR

if [ ! -d "$PATH_ABSOLUTE" ] 
  then
	  echo "Parameter 1 = [ \"$PATH_ABSOLUTE\" ] --> No such directory or path"
    ERR_FLAG=$((ERR_FLAG + 1))
  else
    echo "Parameter 1 = [ \"$PATH_ABSOLUTE\" ] --> OK (Exists)"
    ERROR=$( { `mkdir $PATH_ABSOLUTE/$GENERAT_TMP_DIR | grep denied` | sed s/Output/Useless/; } 2>&1 )
    if [ "$ERROR" = "" ]
      then 
        echo "Permission for [ \"$PATH_ABSOLUTE\" ] --> OK"
        rm -rf $PATH_ABSOLUTE/$GENERAT_TMP_DIR
      else
        echo "WARNING: Permission denied for [ \"$PATH_ABSOLUTE\" ]. Run the script with the 'sudo' command"
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
fi

#check NUM_OF_SUBFOLDERS
REGEX="^[0-9]+$"
if [[ $NUM_OF_SUBFOLDERS =~ $REGEX ]]
  then
    if [ $NUM_OF_SUBFOLDERS -gt 0 ] 
      then
        echo "Parameter 2 = [ \"$NUM_OF_SUBFOLDERS\" ] --> OK"
      else
        echo "Parameter 2 = [ \"$NUM_OF_SUBFOLDERS\" ] --> Shouldn't be equal 0. Use only integer number > 0" 
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 2 = [ \"$NUM_OF_SUBFOLDERS\" ] --> is not integer number or number < 0. Use only integer number > 0."
    ERR_FLAG=$((ERR_FLAG + 1))
fi

#check LIST_LETTERS_FOLDER
if [[ $LIST_LETTERS_FOLDER =~ ^[a-Z]+$ ]]
  then
    LENGTH=${#LIST_LETTERS_FOLDER}
    if [ $LENGTH -gt 0 ] && [ $LENGTH -le 7 ]
      then
        echo "Parameter 3 = [ \"$LIST_LETTERS_FOLDER\" ] --> OK"
      else
        echo "Parameter 3 = [ \"$LIST_LETTERS_FOLDER\" ] --> LENGTH Shouldn't be equal 1 letter or > 7 letters. Use unique letters (>=1 and <=7)."
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 3 = [ \"$LIST_LETTERS_FOLDER\" ] --> is not a list of English alphabet letters."
    ERR_FLAG=$((ERR_FLAG + 1))
fi

#check NUM_OF_FILES_IN_FOLDER
REGEX="^[0-9]+$"
if [[ $NUM_OF_FILES_IN_FOLDER =~ $REGEX ]]
  then
    if [ $NUM_OF_FILES_IN_FOLDER -gt 0 ] 
      then
        echo "Parameter 4 = [ \"$NUM_OF_FILES_IN_FOLDER\" ] --> OK"
      else
        echo "Parameter 4 = [ \"$NUM_OF_FILES_IN_FOLDER\" ] --> Shouldn't be equal 0. Use only integer number > 0" 
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 4 = [ \"$NUM_OF_FILES_IN_FOLDER\" ] --> is not integer number or number < 0. Use only integer number > 0."
    ERR_FLAG=$((ERR_FLAG + 1))
fi


#check LIST_LETTERS_FILE_AND_EXT
if [[ $LIST_LETTERS_FILE_AND_EXT =~ ^[a-Z]+[.]+[a-Z]+$ ]]
  then 
    FILE_NAME="${LIST_LETTERS_FILE_AND_EXT%.[^.]*}"
    EXT_NAME="${LIST_LETTERS_FILE_AND_EXT##*.}"
    LEN_FILE=${#FILE_NAME}
    LEN_EXT=${#EXT_NAME}
    if [ $LEN_FILE -gt 0 ] && [ $LEN_FILE -le 7 ] && [ $LEN_EXT -le 3 ]
      then
        echo "Parameter 5 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> OK"
      else
        echo "Parameter 5 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> length for <LETTERS> shouldn't be > 7 letters. And <ext> shouldn't be > 3 letters"
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 5 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> Does not contain the correct format or is not a list of English alphabet letters."
    ERR_FLAG=$((ERR_FLAG + 1))
fi

#check FILE_SIZE_KB
NUM_SIZE=`echo $FILE_SIZE_KB | grep -o ^[0-9+$]*`
LEN_NUM=${#NUM_SIZE}
TXT_EXT=`echo ${FILE_SIZE_KB:$LEN_NUM} | tr '[:upper:]' '[:lower:]'`

if [ "$NUM_SIZE" = "" ]
  then
    NUM_SIZE=0
  else
  :
fi

if [ "$TXT_EXT" = "" ] || [ "$TXT_EXT" = "kb" ]
  then
    if [ $NUM_SIZE -gt 0 ] && [ $NUM_SIZE -le 100 ]
      then
        echo "Parameter 6 = [ \"$FILE_SIZE_KB\" ] --> OK"
      else
        echo "Parameter 6 = [ \"$FILE_SIZE_KB\" ] --> A number of size zero or greater than 100. Use  0 < [\"number\"] <= 100."
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 6 = [ \"$FILE_SIZE_KB\" ] --> Not correct size type. Use \"kb\" or enter only number."
    ERR_FLAG=$((ERR_FLAG + 1))
fi


exit $ERR_FLAG