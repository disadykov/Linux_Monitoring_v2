#!/bin/bash

MENU_ITEM=$1
FILE_LOG="../log/create_files.log"   #Name for logfile
WORKDIR=`pwd`
COUNT_FILE=0

function clean_logfile {
    echo "Finding and deleting files... Please wait..."
    LOGS="$(cat $FILE_LOG | awk -F ' ' '{print $1}'))"
    REGX='^\/'
    for i in $LOGS:
    do
        if [[ $i =~ $REGX ]]
        then
           sudo chmod 777 $READ_FOLDER 2>/dev/null
           sudo rm -rf $i 2> /dev/null
        fi
    done
}

#Удаление по лог файлу
if [[ $MENU_ITEM -eq 1 ]] 
    then
        if [ -f "$FILE_LOG" ]; then
            clean_logfile
        else 
            echo "Logfile \"$FILE_LOG\" does not exist."
        fi
    else
    :
fi

#Удаление по дате и времени создания (с... по...)
if [[ $MENU_ITEM -eq 2 ]] 
    then
        echo "Enter the date and time (sample: YYYY-MM-DD HH:MM)"
        echo ""
        read -p "Enter START date and time (example: 2023-07-04 12:01): " START_DATE
        read -p "Enter END date and time (example: 2023-07-04 13:00): " END_DATE

        check1=`echo $START_DATE | grep '[a-Z]'`
        check2=`echo $END_DATE | grep '[a-Z]'`

        if [ "$check1" != "" ] || [ "$check2" != "" ]
        then
            echo ""
            echo "Date cannot contain letters. Try again."
            exit 1
        fi

        if [ "`date -d "$END_DATE" +%s`" -gt "`date -d "$START_DATE" +%s`" ]
        then
            echo ""
            echo "Finding and deleting files... Please wait..."

            COUNT_FILE=`sudo find / -newermt "$START_DATE" ! -newermt "$END_DATE" -type f 2>/dev/null | grep '_[0-9][0-9][0-9][0-9][0-9][0-9]\.' | wc -l`
            sudo find / -newermt "$START_DATE" ! -newermt "$END_DATE" -type f 2>/dev/null | grep '_[0-9][0-9][0-9][0-9][0-9][0-9]\.' | xargs rm -rf
            
            COUNT_FOLDERS=$(sudo find / -type d 2>/dev/null | grep '_[0-9][0-9][0-9][0-9][0-9][0-9]$' | wc -l)
            
            for (( i=1; i<=$COUNT_FOLDERS; i++ ))
            do
                PATH_OF_FOLDER=$(sudo find / -type d 2>/dev/null | grep '_[0-9][0-9][0-9][0-9][0-9][0-9]$' | sed -n "$i"p)
                FOLDERS_EMPTY=$(ls $PATH_OF_FOLDER | wc -l)
                if [[ $FOLDERS_EMPTY -eq 0 ]]
                then
                    echo "$PATH_OF_FOLDER" >> tmp_folders_of_empty.log
                fi
            done
                
            COUNT_FOLDERS=$(wc -l $WORKDIR/tmp_folders_of_empty.log | awk '{print $1}')
            while read READ_FOLDER
            do
                sudo chmod 777 $READ_FOLDER 2>/dev/null
                sudo rm -rf $READ_FOLDER 2>/dev/null
            done < $WORKDIR/tmp_folders_of_empty.log

            rm -rf $WORKDIR/tmp_folders_of_empty.log

            echo "DELETE FILES: $COUNT_FILE"
            echo "DELETE FOLDERS: $COUNT_FOLDERS"
        else
            echo ""
            echo "Start date and time cannot be greater than end date and time. Try again."
            exit 1
        fi

fi

#Удаление по маске
if [[ $MENU_ITEM -eq 3 ]] 
    then
        echo "Enter mask for delete: [a-z]_DDMMYY"
        read MASK

        NAME_PART=`echo $MASK | awk -F "_" '{printf $1}'`
        DATE_PART=`echo $MASK | awk -F "_" '{printf $2}'`
        
        part1=`echo $NAME_PART | grep '[0-9]'`
        part2=`echo $DATE_PART | grep '[a-Z]'`

        LENGTH_NAME_PART=${#NAME_PART}
        LENGTH_DATE_PART=${#DATE_PART}

        if [ $LENGTH_NAME_PART -eq 0 ] || [ $LENGTH_DATE_PART -eq 0 ]
        then
            echo "One of the parts does not contain values. Try again"
            exit 1
        else
            if [ "$part1" != "" ] || [ "$part2" != "" ]
            then
                echo ""
                echo "The left side must not contain numbers, and the right side must not contain letters. Try again."
                exit 1
            else
                echo "Finding and deleting files... Please wait..."
                touch tmp_folders.log

                step=1
                count=`sudo find / -type d 2>/dev/null | egrep "*$MASK*" | wc -l`
                for((step = 1; step <= $count; step++)) 
                do
                    sudo find / -type d 2>/dev/null | egrep "*$MASK*" | head -$step | tail +$step >> tmp_folders.log
                done

                while read READ_FOLDER
                do
                    count_f=`find $READ_FOLDER -type f | wc -l`
                    COUNT_FILE=$((COUNT_FILE + $count_f))
                    sudo chmod 777 $READ_FOLDER 2>/dev/null
                    sudo rm -rf $READ_FOLDER 2>/dev/null
                done < $WORKDIR/tmp_folders.log

                rm -rf $WORKDIR/tmp_folders.log
                echo "DELETE FILES: $COUNT_FILE"
                echo "DELETE FOLDERS: $count"
            fi
        fi
fi