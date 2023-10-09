#!/bin/bash

function check_dependences(){
    local dependences[0]="jq"
    local dependences[1]="sqlite3"
    local dependences[2]="gum"
    for i in ${dependences[@]}
    do
        gum spin -s minidot --title.foreground 2 --title "Validando a existencia do pacote ${i}..." -- sleep 1
        if [ $? == 0 ]
        then
           gum spin -s minidot --title.foreground 2 --title "Dependencia ${i}, está instalada..." -- sleep 1
        else
            gum spin -s minidot --title.foreground 1 --title "Dependencia ${i}, não está instalada, por favor leie o README do projeto e instale..." -- sleep 2 && exit
        fi
    done
}

check_dependences