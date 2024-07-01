#!/bin/bash

MENU_ITEM=$1              #Parameter 1. Menu item
ERR_FLAG=0                #No errors

#check MENU_ITEM
REGEX="^[0-9]+$"
if [[ $MENU_ITEM =~ $REGEX ]]
  then
    if [[ ${MENU_ITEM} -gt 4 || ${MENU_ITEM} -lt 1 ]]
      then
        ERR_FLAG=$((ERR_FLAG + 1))
    fi
  else
    ERR_FLAG=$((ERR_FLAG + 1))
fi

exit $ERR_FLAG