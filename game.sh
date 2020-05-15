#!/bin/bash

map=("0" "1" "2" "3" "4" "5" "6" "7" "8")

clear

function print_map {
    echo "Map:"
    echo "${map[0]} | ${map[1]} | ${map[2]}"
    echo "${map[3]} | ${map[4]} | ${map[5]}"
    echo "${map[6]} | ${map[7]} | ${map[8]}"
}

function check_won {
    #горизонталь
    if [[ (${map[0]} == ${map[1]}) && (${map[1]} == ${map[2]}) ]]; then
            echo "${map[0]} won"; exit;  fi
    if [[ (${map[3]} == ${map[4]}) && (${map[4]} == ${map[5]}) ]]; then
            echo "${map[3]} won"; exit;  fi
    if [[ (${map[6]} == ${map[7]}) && (${map[7]} == ${map[8]}) ]]; then
            echo "${map[6]} won"; exit;  fi
    #вертикаль
    if [[ (${map[0]} == ${map[3]}) && (${map[3]} == ${map[6]}) ]]; then
            echo "${map[0]} won"; exit;  fi
    if [[ (${map[1]} == ${map[4]}) && (${map[4]} == ${map[7]}) ]]; then
            echo "${map[1]} won"; exit;  fi
    if [[ (${map[2]} == ${map[5]}) && (${map[5]} == ${map[8]}) ]]; then
            echo "${map[2]} won"; exit;  fi
    #диагональ
    if [[ (${map[0]} == ${map[4]}) && (${map[4]} == ${map[8]}) ]]; then
            echo "${map[0]} won"; exit;  fi
    if [[ (${map[2]} == ${map[4]}) && (${map[4]} == ${map[6]}) ]]; then
            echo "${map[2]} won"; exit; fi
}

function check_draw {
    draw=1
    for i in {0..8}
    do
        if [[ (${map[i]} != 'X') && (${map[i]} != 'O') ]]
        then
            return
        fi
    done
    echo "Draw"
    exit
}


function my_turn {
    read -n 1 value_1
    echo
    clear

    while [[ ${map[$value_1]} != $value_1 ]]
    do
        print_map
        echo "Enter correct step:"
        read -n 1 value_1
        clear
    done

    echo $value_1 >& ${COPROC[1]}

    map[$value_1]="$1"

    print_map

    check_won
    check_draw
}

function his_turn {
    read -u ${COPROC[0]} coord_2
    map[$coord_2]="$1"

    clear
    print_map
    check_won
    check_draw
}


print_map


if [[ $2 ]]
then 
    coproc nc -w 70 $1 $2  
    while [[ true ]]
    do
        echo "Player 1:"
        my_turn "X"
        his_turn "O"

    done
else
    coproc nc -l -p $1
    while [[ true ]]
    do
        his_turn "X"
        echo "Player 2:"
        my_turn "O"
    done
fi
