#!/bin/bash

function get_status(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/status)"
}

function get_temp(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/temp | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_temp_hot1(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/hw_temp_warn1 | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_temp_hot1_en(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/hw_temp_warn1_en)"
}

function get_temp_hot2(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/hw_temp_warn2 | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_temp_hot2_en(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/hw_temp_warn2_en)"
}

function get_temp_tripp0(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/trip_point0_temp | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_temp_tripp1(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/trip_point1_temp | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_temp_tripp2(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/trip_point2_temp | sed 's/.\{3\}$/.&/' | sed 's/.\{1\}$//')"
}

function get_framework_version(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/framework_version)"
}

function get_driver_version(){
echo -n "$(cat /sys/$(udevadm info --query=path --name=/dev/$1)/driver_version)"
}

$@
