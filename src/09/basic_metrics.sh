#!/bin/bash

CPU_USER=`top -b | head -3 | tail +3 | awk '{print $2}' | awk -F "," '{print $1 "." $2}'`
CPU_KERNEL=`top -b | head -3 | tail +3 | awk '{print $4}' | awk -F "," '{print $1 "." $2}'`
RAM_FREE=`free -m | grep Mem: | awk '{print $4}'`
RAM_USED=`free -m | grep Mem: | awk '{print $3}'`
RAM_TOTAL=`free -m | grep Mem: | awk '{print $2}'`
DISK_USED=`df / | tail -n1 | awk '{print $3}'`
DISK_SIZE=`df / | tail -n1 | awk '{print $2}'`

echo \# HELP s21_cpu_usage_user CPU usage user.
echo \# TYPE s21_cpu_usage_user gauge
echo s21_cpu_usage_user $CPU_USER

echo \# HELP s21_cpu_usage_kernel CPU usage kernel.
echo \# TYPE s21_cpu_usage_kernel gauge
echo s21_cpu_usage_kernel $CPU_KERNEL

echo \# HELP s21_ram_free Free memory.
echo \# TYPE s21_ram_free gauge
echo s21_ram_free $RAM_FREE

echo \# HELP s21_ram_used Used memory.
echo \# TYPE s21_ram_used gauge
echo s21_ram_used $RAM_USED

echo \# HELP s21_ram_total Total memory.
echo \# TYPE s21_ram_total gauge
echo s21_ram_total $RAM_TOTAL


echo \# HELP s21_disk_used Used disk.
echo \# TYPE s21_disk_used gauge
echo s21_disk_used $DISK_USED

echo \# HELP s21_disk_size Size disk.
echo \# TYPE s21_disk_size gauge
echo s21_disk_size $DISK_SIZE


