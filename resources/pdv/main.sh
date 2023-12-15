#!/bin/bash

function menu_products(){
    clear;
    header
    gum style "$(gum style --foreground 212 ${username}), escolha uma opção!"
    local menu_products=$(gum choose --selected.foreground="3" --header.foreground="3" --cursor.foreground="3" --cursor-prefix "[ ] " --selected-prefix "[✓] " "${menu_product_add}" "${menu_product_rm}" "${menu_product_stock}" "${menu_main}" "${menu_exit}" )
    grep -q "${menu_product_add}"    <<< "${menu_products}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && add_product
    grep -q "${menu_product_rm}"     <<< "${menu_products}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && rm_product
    grep -q "${menu_product_stock}"  <<< "${menu_products}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && check_stock
    grep -q "${menu_main}"           <<< "${menu_products}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_main
    grep -q "${menu_exit}"           <<< "${menu_products}" && gum spin -s minidot --title "Saindo do pdvshell..." -- sleep 1 && menu_exit

}

function menu_users(){
    clear;
    header
    gum style "$(gum style --foreground 212 ${username}), escolha uma opção!"
    local menu_users=$(gum choose --selected.foreground="3" --header.foreground="3" --cursor.foreground="3" --cursor-prefix "[ ] " --selected-prefix "[✓] " "${menu_users_add}" "${menu_main}" "${menu_exit}" )
    grep -q "${menu_users_add}"  <<< "${menu_users}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && add_user
    grep -q "${menu_main}"        <<< "${menu_users}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_main
    grep -q "${menu_exit}"        <<< "${menu_users}" && gum spin -s minidot --title "Saindo do pdvshell..." -- sleep 1 && menu_exit
}

function menu_report(){
    clear;
    header
    gum style "$(gum style --foreground 212 ${username}), escolha uma opção!"
    local menu_report=$(gum choose --selected.foreground="3" --header.foreground="3" --cursor.foreground="3" --cursor-prefix "[ ] " --selected-prefix "[✓] " "${menu_report_sales_diary}" "${menu_report_sales_week}" "${menu_report_sales_month}" "${menu_report_sales_year}" "${menu_main}" "${menu_exit}" )
    grep -q "${menu_report_sales_diary}"  <<< "${menu_report}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && report_daily
    grep -q "${menu_report_sales_week}"   <<< "${menu_report}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && report_week
    grep -q "${menu_report_sales_month}"  <<< "${menu_report}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && report_month
    grep -q "${menu_report_sales_year}"   <<< "${menu_report}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && report_year
    grep -q "${menu_main}"                <<< "${menu_users}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_main
    grep -q "${menu_exit}"                <<< "${menu_report}" && gum spin -s minidot --title "Saindo do pdvshell..." -- sleep 1 && menu_exit
}

function menu_exit(){
    clear
    exit    
}

function menu_main(){
    local query_check_admin="SELECT is_admin FROM users WHERE username='${username}'"
    local check_admin=$( sqlite3 "${resources_db_database}" "${query_check_admin}" )

    if [[ "${check_admin}" == "0" ]];    then
        gum spin -s minidot --title.foreground 2 --title "Carregando menu, por favor aguarde..." -- sleep 2 && menu_no_admin
    elif [[ "${check_admin}" == "1" ]];
    then
        gum spin -s minidot --title.foreground 2 --title "Carregando menu Admin, por favor aguarde..." -- sleep 2 && menu_admin
    else
        gum spin -s minidot --title.foreground 1 --title "Falha no login, por favor aguarde..." -- sleep 1 && login
    fi
}

function menu_admin(){
    clear;
    header
    gum style "$(gum style --foreground 212 ${username}), escolha uma opção!"
    local menu_admin=$(gum choose --selected.foreground="3" --header.foreground="3" --cursor.foreground="3" --cursor-prefix "[ ] " --selected-prefix "[✓] " "${menu_products}" "${menu_users}" "${menu_report}" "${menu_sales}" "${menu_exit}" )
    grep -q "${menu_products}"  <<< "${menu_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_products
    grep -q "${menu_users}"    <<< "${menu_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_users
    grep -q "${menu_report}"    <<< "${menu_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && menu_report
    grep -q "${menu_sales}"     <<< "${menu_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && sell_products
    grep -q "${menu_exit}"      <<< "${menu_admin}" && gum spin -s minidot --title "Saindo do pdvshell..." -- sleep 1 && menu_exit

}

function menu_no_admin(){
    clear;
    header
    gum style "$(gum style --foreground 212 ${username}), escolha uma opção!"
    local menu_no_admin=$(gum choose --selected.foreground="3" --header.foreground="3" --cursor.foreground="3" --cursor-prefix "[ ] " --selected-prefix "[✓] " "${menu_sales}" "${menu_products}" "${menu_report}" "${menu_exit}" )
    grep -q "${menu_products}" <<< "${menu_no_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && add_product
    grep -q "${menu_report}"   <<< "${menu_no_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && sell_products
    grep -q "${menu_sales}"    <<< "${menu_no_admin}" && gum spin -s minidot --title "Por favor aguarde..." -- sleep 1 && sell_products
    grep -q "${menu_exit}"     <<< "${menu_no_admin}" && gum spin -s minidot --title "Saindo do pdvshell..." -- sleep 1 && menu_exit

}