#!/bin/bash
clear

if [ -n "$1" ]
  then
      echo "The script: [$0] must be run without parmaters. Try again!"
  else
    ./install.sh
    ./configure.sh
    clear
    echo "Program is work..."
    echo "Usage \"CTRL+C\" for exit..."
    while sleep 3
    do
        sudo ./basic_metrics.sh > /var/www/html/basic_metrics.html
    done
    
fi


