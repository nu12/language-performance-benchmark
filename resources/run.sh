#!/bin/bash

for I in $(seq 1 $4)
do
 
    if [ "$1" = "cmd" ]
    then
        export START=`date +%s%N`; 	
        $2;
        export END=`date +%s%N`; 
        echo -n "," >> "outputs/$3.csv"
        echo -n $START >> "outputs/$3.csv"
        echo -n "," >> "outputs/$3.csv"
        echo $END >> "outputs/$3.csv"
    else
    
        export START=`date +%s%N`; 	
        $1 $2;
        export END=`date +%s%N`; 
        echo -n "," >> "outputs/$3.csv"
        echo -n $START >> "outputs/$3.csv"
        echo -n "," >> "outputs/$3.csv"
        echo $END >> "outputs/$3.csv"
    fi
    
    
done