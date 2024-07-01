#/bin/bash

LIST_LETTERS_FOLDER=$1        #Parameter 1 is a list of English alphabet letters used in folder names (no more than 7 characters).
LIST_LETTERS_FILE_AND_EXT=$2  #Parameter 5 - the list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension).

FILE_SIZE_MB=$3               #Parameter 3 - file size (in Mb, but not more than 100).
NUM_SIZE=`echo $FILE_SIZE_MB | grep -o ^[0-9+$]*`
FILE_SIZE_MB=$NUM_SIZE

START_SCRIPT=$4
start_time=$5

DATE=`date '+%d%m%y'`         #Today's date in format DDMMYY
DATE_LOG=`date +'%Y-%m-%d %H:%M:%S'`   #Today's date in format DD.MM.YY HH:MM:SS

FILE_LOG="../log/create_files.log"   #Name for logfile
LEN_LIST_LETTERS_FOLDER=${#LIST_LETTERS_FOLDER} #Length for LIST_LETTERS_FOLDER

NUM_OF_SUBFOLDERS=100

YES_FOLDER_CREATE=0
YES_FILE_CREATE=0
STEP_FOLDER=0
STEP_FILE=0

echo "--------------------------------------------------------"
echo "Waiting... Create folders and files..."

if [ -f "$FILE_LOG" ]; then
        :
    else 
        mkdir ../log 2> /dev/null
        touch $FILE_LOG
fi

function work_time {
    END_SCRIPT=`date +'%Y-%m-%d %H:%M:%S'`
    end_time=`date +%s%N`
    echo "Script start time: $START_SCRIPT"
    echo "Script end time: $END_SCRIPT"
    result_time=$(($end_time-$start_time))
    seconds_up=$(bc<<<"$result_time/1000000000")
    minuts=$(bc<<<"$seconds_up/60")
    seconds=$(bc<<<"$seconds_up%60")
    echo "Time work sript: $minuts (min) $seconds (sec)"
    echo "Script start time: $START_SCRIPT -- Script end time: $END_SCRIPT -- Time work sript: $minuts (min) $seconds (sec)" >> $FILE_LOG
}

function free_space_root {
    local MB=1024
    local SPACE_GB_FREE=`df -h / | grep / | awk '{print $4}'`
    local SMALL_SIZE=`echo $SPACE_GB_FREE | grep '0\,'`
    if [ "$SMALL_SIZE" != "" ]
    then
        echo "WARNING: Too little free space (< 1GB). Program stopped!"
        echo "FOLDERS CREATE: $YES_FOLDER_CREATE"
        echo "FILES CREATE: $YES_FILE_CREATE"
        work_time
        exit 1
    else
        SPACE_GB=`echo $SPACE_GB_FREE | grep -o ^[0-9+$]*`
        local SPACE_ROOT_FREE=$(bc<<<"$SPACE_GB*$MB")
        echo $SPACE_ROOT_FREE
    fi
}

function random_num {
    local MAX_VALUE=$1
    local NUMBER=-1
    while [[ $NUMBER -gt $MAX_VALUE ]] || [[ $NUMBER -le 0 ]];
    do
        local NUMBER=$RANDOM
    done
    echo $NUMBER
}

function arr_empty {
    local i=$1
    PATH_FOLDER[$i]="empty"
}

sudo find / -type d 2> /dev/null | grep -v -e bin -e sbin -e Permission -e proc -e snap -e sys -e run -e boot > folder_tmp.txt

declare -a PATH_FOLDER=()

function path_generate {
    while :
    do
        RANDOM_PATH=$(random_num $PATH_FOLDER_SIZE)
        RANDOM_PATH=$(($RANDOM_PATH - 1))
        PATH_GENERATE=${PATH_FOLDER[$RANDOM_PATH]}
        if [ "$PATH_GENERATE" != "empty" ]
        then
            arr_empty $RANDOM_PATH
            break
        fi
    done        
    
    echo "$PATH_GENERATE/"
}

while read READ_FOLDER
do
    PATH_FOLDER+=($READ_FOLDER)
done < folder_tmp.txt
rm -rf folder_tmp.txt



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
    sudo mkdir $PATH_FINAL 2> /dev/null
    if [ $? -eq 0 ] 
    then
        YES_FOLDER_CREATE=$((YES_FOLDER_CREATE + 1))  
        echo "$PATH_ABSOLUTE$FOLDER_NAME --- $DATE_LOG ---"  >> $FILE_LOG
        sudo chmod 777 $PATH_FINAL 2>/dev/null
    fi
}

function create_files {

    NUM_OF_FILES_IN_FOLDER=$(random_num 100)
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
    sudo fallocate -l $FILE_SIZE_MB"MB" $PATH_FINAL/$FILE_NAME 2> /dev/null
    if [ $? -eq 0 ] 
        then
            YES_FILE_CREATE=$((YES_FILE_CREATE + 1))  
            echo "$PATH_ABSOLUTE$FOLDER_NAME/$FILE_NAME --- $DATE_LOG --- $FILE_SIZE_MB Mb" >> $FILE_LOG
    fi

    SPACE_ROOT_FREE=$(free_space_root)
    if [ $SPACE_ROOT_FREE -le 1000 ]
    then
        echo "WARNING: Too little free space (< 1GB). Program stopped!"
        echo "FOLDERS CREATE: $YES_FOLDER_CREATE"
        echo "FILES CREATE: $YES_FILE_CREATE"
        work_time
        exit 1
    fi
}

PATH_FOLDER_SIZE=${#PATH_FOLDER[@]}
PATH_FOLDER_SIZE_FOR_ARR=$(($PATH_FOLDER_SIZE - 1))

for (( count_folder = 0; count_folder <$PATH_FOLDER_SIZE; count_folder++ ))
do
    FOLDER_NAME_SAVE=""
    PATH_ABSOLUTE=$(path_generate)
    echo "Creation in: $PATH_ABSOLUTE"

if [ $LEN_LIST_LETTERS_FOLDER -gt 3 ]
then
    FOLDER_NAME_SAVE=""
    FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
else
    FOLDER_NAME_SAVE+="$(echo ${LIST_LETTERS_FOLDER:0:1})"
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

create_folders_and_files
done
echo ""
echo "FOLDERS CREATE: $YES_FOLDER_CREATE"
echo "FILES CREATE: $YES_FILE_CREATE"
work_time

echo "--------------------------------------------------------"

