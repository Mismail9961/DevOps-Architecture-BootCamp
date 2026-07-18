#!/bin/bash

name=""

gender=("A) Male" "B) Female")

while getopts "n:" opt; do 
    case $opt in 
        n) name=$OPTARG ;;
        *) echo "Invalid option" ;;
    esac
done 

greet() {
    echo "Hi, Hope you are doing well, $1"
}

if [[ -z $name ]]; then 
    echo "Please provide your name using -n option"
    exit 1
else
    greet $name
fi

echo "Welcome $name"
echo "Please Select Your Gender"


for ((i=0; i<${#gender[@]}; i++));
do
    echo "${gender[$i]}"
done

echo $gndr

while true; do
    read -r gndr

    gndr=${gndr^^}

    if [[ $gndr == "A" || $gndr == "B" ]]; then
        case $gndr in
            A) gndr="Male" ;;
            B) gndr="Female" ;;
        esac
        echo "You have selected $gndr"
        break
    else
        echo "Invalid selection. Please select A or B"
    fi
done
