#!/bin/bash

function random {
    local min_value=$1
    local max_value=$2
    local num_random=$(($min_value-1))
    while [[ $num_random -lt $min_value || $num_random -gt $max_value ]]
    do
        local num_random=$RANDOM
    done
    echo $num_random
}

function generate_ip {
    local ip=$(random 1 254)
    for((i=0; i<3; i++))
    do
        local ip+="."$(random 1 254)
    done
    echo $ip
}

function month_en {
  local month=$1
  case "$month" in
  "01" )
    EN="Jan"
  ;;
  "02" )
    EN="Feb"
  ;;
  "03" )
    EN="Mar"
  ;;
  "04" )
    EN="Apr"
  ;;
  "05" )
    EN="May"
  ;;
  "06" )
    EN="Jun"
  ;;
  "07" )
    EN="Jul"
  ;;
  "08" )
    EN="Aug"
  ;;
  "09" )
    EN="Sep"
  ;;
  "10" )
    EN="Oct"
  ;;
  "11" )
    EN="Nov"
  ;;
  "12" )
    EN="Dec"
  ;;
  esac
  echo $EN
}

function time_generate {
  local step=$1
  local total=$2
  local time_gen=""
  local one_day=86340
  local second_of_step=$(bc<<<"$one_day/$total")
  local step_second=$(bc<<<"$second_of_step*$step")
  local sec_random=`random 1 30`
  step_second=$(( step_second + $sec_random ))

  local hour_int=$(bc<<<"$step_second/3600")
  if [ $hour_int -lt 10 ]
  then
    time_gen+="0"
  fi
  time_gen+="$hour_int"
  time_gen+=":"

  local hour_mod=$(bc<<<"$step_second%3600")
  local min_int=$(bc<<<"$hour_mod/60")

  if [ $min_int -lt 10 ]
  then
    time_gen+="0"
  fi
  time_gen+="$min_int"
  time_gen+=":"

  local min_mod=$(bc<<<"$hour_mod%60")
  if [ $min_mod -lt 10 ]
  then
    time_gen+="0"
  fi
  time_gen+="$min_mod"
  echo $time_gen
}

function method_generate {
    local METHODS=(GET POST PUT PATCH DELETE)
    local number=$(random 0 4)
    echo ${METHODS[$number]}
}

function protocol_generate {
    local PROTOCOL=(http https)
    local number=$(random 0 1)
    echo ${METHODS[$number]}  
}

function ext_generate {
    local PROTOCOL=(html php)
    local number=$(random 0 1)
    echo ${METHODS[$number]}  
}

function status_generate {
    local STATUS=(200 201 400 401 403 404 500 501 502 503)
    local number=$(random 0 9)
    echo ${STATUS[$number]}
}

echo "Creating log files... Please wait..."
TZONE=`date '+%z'`

echo -n "" > agent.txt
./user_agent.sh
RECORDS_FILE=0
declare -a USER_AGENT=()
while read READ_FOLDER
do
    USER_AGENT+=("$READ_FOLDER")
    RECORDS_FILE=$((RECORDS_FILE + 1))
done < agent.txt
rm -rf agent.txt
RECORDS_FILE=$((RECORDS_FILE - 1))

for i in {0..4}
do
  RECORDS=`random 100 1000`
  NUM_DAY=$(( $i + 1 ))
  echo -n > day_$NUM_DAY.log
  day=$(date -d '-'$i' day' '+%d')
  month_tmp=$(date -d '-'$i' day' '+%m')
  month=$(month_en $month_tmp)
  year=$(date -d '-'$i' day' '+%Y')
  
  for (( j=0; j <$RECORDS; j++ ))
  do
    TIME_GEN=$(time_generate $j $RECORDS)
    METHOD_GEN=$(method_generate)
    URL_GEN=`./url_generator.sh`
    STATUS_GEN=$(status_generate)
    RANDOM_AGENT=`random 0 $RECORDS_FILE`
    AGENT_GEN=${USER_AGENT[$RANDOM_AGENT]}
    if [ $STATUS_GEN -le 201 ]
    then
      BYTE_GEN=`random 100 999`
      URL_AGENT=`./url_generator.sh`
    else
      BYTE_GEN=`random 0 10`
      URL_AGENT="-"
    fi


    echo "`generate_ip` - - [$day/$month/$year:$TIME_GEN $TZONE] \"$METHOD_GEN $URL_GEN HTTP/1.1\" $STATUS_GEN $BYTE_GEN \"$URL_AGENT\" \"$AGENT_GEN\"" >> day_$NUM_DAY.log
  done

  echo "LOG FILES \"day_$NUM_DAY.log\" SUCCESSFULLY CREATED (RECORDS: $RECORDS)"
done

