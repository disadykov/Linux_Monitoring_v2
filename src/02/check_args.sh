#!/bin/bash

LIST_LETTERS_FOLDER=$1        #Parameter 1 is a list of English alphabet letters used in folder names (no more than 7 characters).
LIST_LETTERS_FILE_AND_EXT=$2  #Parameter 2 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).
FILE_SIZE_MB=$3               #Parameter 3 - file size (in kilobytes, but not more than 100).

ERR_FLAG=0                    #No errors


#check LIST_LETTERS_FOLDER
if [[ $LIST_LETTERS_FOLDER =~ ^[a-Z]+$ ]]
  then
    LENGTH=${#LIST_LETTERS_FOLDER}
    if [ $LENGTH -gt 0 ] && [ $LENGTH -le 7 ]
      then
        echo "Parameter 1 = [ \"$LIST_LETTERS_FOLDER\" ] --> OK"
      else
        echo "Parameter 1 = [ \"$LIST_LETTERS_FOLDER\" ] --> LENGTH Shouldn't be equal 1 letter or > 7 letters. Use unique letters (>=1 and <=7)."
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 1 = [ \"$LIST_LETTERS_FOLDER\" ] --> is not a list of English alphabet letters."
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
        echo "Parameter 2 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> OK"
      else
        echo "Parameter 2 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> length for <LETTERS> shouldn't be > 7 letters. And <ext> shouldn't be > 3 letters"
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 2 = [ \"$LIST_LETTERS_FILE_AND_EXT\" ] --> Does not contain the correct format or is not a list of English alphabet letters."
    ERR_FLAG=$((ERR_FLAG + 1))
fi

#check FILE_SIZE_MB
NUM_SIZE=`echo $FILE_SIZE_MB | grep -o ^[0-9+$]*`
LEN_NUM=${#NUM_SIZE}
TXT_EXT=`echo ${FILE_SIZE_MB:$LEN_NUM} | tr '[:upper:]' '[:lower:]'`

if [ "$NUM_SIZE" = "" ]
  then
    NUM_SIZE=0
  else
  :
fi

if [ "$TXT_EXT" = "" ] || [ "$TXT_EXT" = "mb" ]
  then
    if [ $NUM_SIZE -gt 0 ] && [ $NUM_SIZE -le 100 ]
      then
        echo "Parameter 3 = [ \"$FILE_SIZE_MB\" ] --> OK"
      else
        echo "Parameter 3 = [ \"$FILE_SIZE_MB\" ] --> A number of size zero or greater than 100. Use  0 < [\"number\"] <= 100."
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    echo "Parameter 3 = [ \"$FILE_SIZE_MB\" ] --> Not correct size type. Use \"mb\" or enter only number."
    ERR_FLAG=$((ERR_FLAG + 1))
fi


exit $ERR_FLAG