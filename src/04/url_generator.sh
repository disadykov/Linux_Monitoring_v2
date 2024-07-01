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

function protocol_generate {
    local PROTOCOL=(http https)
    local number=$(random 0 1)
    echo ${PROTOCOL[$number]}  
}

function ext_generate {
    local EXT=(html php)
    local number=$(random 0 1)
    echo ${EXT[$number]}  
}

function domen_generate {
    local DOMEN=(com ru org info biz net su)
    local number=$(random 0 6)
    echo ${DOMEN[$number]}  
}

function site_generate {
    local SITE_NAME=$(random 4 8)
    #случайная последовательность символов
    local SITE=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-$SITE_NAME} | head -n 1`

    local site_gen=`echo $SITE | tr [:upper:] [:lower:]`
    echo $site_gen
}

function page_generate {
    local count_page=$(random 1 3)
    local page_path=""
    for (( count = 0; count <$count_page; count++ ))
    do
        page_path+="/"
        local page_gen=$(site_generate)
        page_path+="$page_gen"
    done
    echo $page_path
}

PROTOCOL_GEN=$(protocol_generate)
EXT_GEN=$(ext_generate)
DOMEN_GEN=$(domen_generate)
SITE_GEN=$(site_generate)
PAGE_GEN=$(page_generate)

echo "$PROTOCOL_GEN://$SITE_GEN.$DOMEN_GEN$PAGE_GEN.$EXT_GEN"

