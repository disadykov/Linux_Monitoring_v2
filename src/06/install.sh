#!/bin/bash

  #install
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install goaccess -y
      
  #configure
  sudo cp goaccess.conf /etc/goaccess/goaccess.conf




