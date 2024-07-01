#/bin/bash

PATH_ABSOLUTE=$1              #Parameter 1 is the absolute PATH_ABSOLUTE
PATH_ABSOLUTE_LEN=`expr length $PATH_ABSOLUTE`
LASTCHAR=`expr substr $PATH_ABSOLUTE $PATH_ABSOLUTE_LEN 1`
if [ "$LASTCHAR" = "/" ]
  then
  :
  else
    CH="/"
    PATH_ABSOLUTE=$PATH_ABSOLUTE$CH
fi  

NUM_OF_SUBFOLDERS=$2          #Parameter 2 is the number of subfolders
LIST_LETTERS_FOLDER=$3        #Parameter 3 is a list of English alphabet letters used in folder names (no more than 7 characters).
NUM_OF_FILES_IN_FOLDER=$4     #Parameter 4 is the number of files in each created folder.
LIST_LETTERS_FILE_AND_EXT=$5  #Parameter 5 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).

FILE_SIZE_KB=$6               #Parameter 6 - file size (in kilobytes, but not more than 100).
NUM_SIZE=`echo $FILE_SIZE_KB | grep -o ^[0-9+$]*`
FILE_SIZE_KB=$NUM_SIZE

DATE=`date '+%d%m%y'`         #Today's date in format DDMMYY
DATE_LOG=`date +'%Y-%m-%d %H:%M:%S'`   #Today's date in format DD.MM.YY HH:MM:SS

FILE_LOG="../log/create_files.log"   #Name for logfile
LEN_LIST_LETTERS_FOLDER=${#LIST_LETTERS_FOLDER} #Length for LIST_LETTERS_FOLDER
echo "--------------------------------------------------------"
echo "Waiting... Create folders and files..."

if [ $LEN_LIST_LETTERS_FOLDER -gt 3 ]
then
    FOLDER_NAME_SAVE=""
else
    FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
    if [ $LEN_LIST_LETTERS_FOLDER -eq 2 ]
    then
        FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
    fi
    if [ $LEN_LIST_LETTERS_FOLDER -eq 1 ]
    then
        FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
        FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
    fi
fi

YES_FOLDER_CREATE=0
YES_FILE_CREATE=0
NO_FOLDER_CREATE=0
NO_FILE_CREATE=0
STEP_FOLDER=0
STEP_FILE=0

if [ -f "$FILE_LOG" ]; then
        :
    else 
        mkdir ../log
fi

touch $FILE_LOG

function free_space_root {
    local MB=1024
    local SPACE_BYTE_FREE=`df / | grep / | awk '{print $4}'`
    local SPACE_ROOT_FREE=$(bc<<<"$SPACE_BYTE_FREE/$MB")
    echo $SPACE_ROOT_FREE
}

function create_folders_and_files {
    for (( count_folder = 0; count_folder <$NUM_OF_SUBFOLDERS; count_folder++ ))
    do
        FOLDER_NAME=$FOLDER_NAME_SAVE
        create_folder_name
        FILE_NAME_SAVE=""
        FILE_NAME_BASE="$(echo $LIST_LETTERS_FILE_AND_EXT | awk -F "." '{print $1}')"
        FILE_NAME_EXT="$(echo $LIST_LETTERS_FILE_AND_EXT | awk -F "." '{print $2}')"
        LEN_FILE_NAME_BASE=${#FILE_NAME_BASE}

    if [ $LEN_FILE_NAME_BASE -gt 3 ]
        then
            FILE_NAME_SAVE=""
        else
            FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
            if [ $LEN_FILE_NAME_BASE -eq 2 ]
                then
                    FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                fi
            if [ $LEN_FILE_NAME_BASE -eq 1 ]
                then
                    FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                    FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
            fi
    fi
    create_files
    done
}

function create_folder_name {
    FOLDER_NAME+="$(echo ${LIST_LETTERS_FOLDER:$STEP_FOLDER:1})"
    FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
    FOLDER_NAME+="$(echo ${LIST_LETTERS_FOLDER:1:$LEN_LIST_LETTERS_FOLDER})"
    FOLDER_NAME+="_"
    FOLDER_NAME+=$DATE
    local FOLDER_NAME_MAX=$PATH_ABSOLUTE
    FOLDER_NAME_MAX+=$FOLDER_NAME
    FOLDER_NAME_MAX+="/"
    local FOLDER_LEN_MAX=${#FOLDER_NAME_MAX}
    if [ $FOLDER_LEN_MAX -ge 200 ] && [ $LEN_LIST_LETTERS_FOLDER -ge 1 ]
        then
            STEP_FOLDER=$((STEP_FOLDER + 1))
            FOLDER_NAME_SAVE=$LIST_LETTERS_FOLDER
            FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:$STEP_FOLDER:1})"
            FOLDER_NAME=$FOLDER_NAME_SAVE
            FOLDER_NAME+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
            FOLDER_NAME+="_"
            FOLDER_NAME+=$DATE
        fi
    PATH_FINAL=""
    PATH_FINAL+=$PATH_ABSOLUTE
    PATH_FINAL+=$FOLDER_NAME
    DATE_LOG=`date +'%Y-%m-%d %H:%M:%S'`   #Today's date in format DD.MM.YY HH:MM:SS
    mkdir $PATH_FINAL
    if [ $? -eq 0 ] 
    then
        YES_FOLDER_CREATE=$((YES_FOLDER_CREATE + 1))  
        echo "$PATH_ABSOLUTE$FOLDER_NAME --- $DATE_LOG ---"  >> $FILE_LOG
    fi
}

function create_files {

    for (( count_files=0; count_files <$NUM_OF_FILES_IN_FOLDER; count_files++ ))
    do
        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
        FILE_NAME=$FILE_NAME_SAVE
        create_filename
    done
}

function create_filename {
    FILE_NAME+="$(echo ${FILE_NAME_BASE:$STEP_FILE:1})"
    FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
    FILE_NAME+="$(echo ${FILE_NAME_BASE:1:$LEN_FILE_NAME_BASE})"
    FILE_NAME+="_"
    FILE_NAME+=$DATE
    FILE_NAME+="."
    FILE_NAME+=$FILE_NAME_EXT

    local FOLDER_NAME_MAX=$PATH_ABSOLUTE
    FOLDER_NAME_MAX+=$PATH_FINAL
    FOLDER_NAME_MAX+=$FILE_NAME
    local FOLDER_LEN_MAX=${#FOLDER_NAME_MAX}
    if [ $FOLDER_LEN_MAX -ge 248 ] && [ $LEN_FILE_NAME_BASE -ge 1 ]
    then
        STEP_FILE=$((STEP_FILE + 1))
        FILE_NAME_SAVE=$FILE_NAME_BASE
        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:$STEP_FILE:1})"
        FILE_NAME=$FILE_NAME_SAVE

        LEN_FILE_NAME_SAVE=${#FILE_NAME}

        if [ $LEN_FILE_NAME_SAVE -eq 3 ]
            then
                FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
            else
                if [ $LEN_FILE_NAME_SAVE -eq 2 ]
                    then
                        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                    fi
                if [ $LEN_FILE_NAME_SAVE -eq 1 ]
                    then
                        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                        FILE_NAME_SAVE+="$(echo ${FILE_NAME_BASE:0:1})"
                fi
        fi
        FILE_NAME+="$(echo ${FILE_NAME_BASE:0:1})"
        FILE_NAME+="$(echo ${FILE_NAME_BASE:0:1})"
        FILE_NAME+="_"
        FILE_NAME+=$DATE
        FILE_NAME+="."
        FILE_NAME+=$FILE_NAME_EXT
    fi
    
    DATE_LOG=`date +'%Y-%m-%d %H:%M:%S'`   #Today's date in format DD.MM.YY HH:MM:SS
    fallocate -l $FILE_SIZE_KB"KB" $PATH_FINAL/$FILE_NAME
    if [ $? -eq 0 ] 
        then
            YES_FILE_CREATE=$((YES_FILE_CREATE + 1))  
            echo "$PATH_ABSOLUTE$FOLDER_NAME/$FILE_NAME --- $DATE_LOG --- $FILE_SIZE_KB Kb" >> $FILE_LOG
    fi

    SPACE_ROOT_FREE=$(free_space_root)
    if [ $SPACE_ROOT_FREE -le 1024 ]
    then
        echo "WARNING: Too little free space (< 1GB). Program stopped!"
        echo "FOLDERS CREATE: $YES_FOLDER_CREATE"
        NO_FOLDER_CREATE=$(( NUM_OF_SUBFOLDERS - YES_FOLDER_CREATE))
        echo "FOLDERS NOT CREATE: $NO_FOLDER_CREATE"
        echo "FILES CREATE: $YES_FILE_CREATE"
        NO_FILE_CREATE=$(( NUM_OF_FILES_IN_FOLDER * NUM_OF_SUBFOLDERS - YES_FILE_CREATE))
        echo "FILES NOT CREATE: $NO_FILE_CREATE"
        exit 1
    fi
}

create_folders_and_files

echo "FOLDERS CREATE: $YES_FOLDER_CREATE"
NO_FOLDER_CREATE=$(( NUM_OF_SUBFOLDERS - YES_FOLDER_CREATE))
echo "FOLDERS NOT CREATE: $NO_FOLDER_CREATE"
echo "FILES CREATE: $YES_FILE_CREATE"
NO_FILE_CREATE=$(( NUM_OF_FILES_IN_FOLDER * NUM_OF_SUBFOLDERS - YES_FILE_CREATE))
echo "FILES NOT CREATE: $NO_FILE_CREATE"

echo "--------------------------------------------------------"