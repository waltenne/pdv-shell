#!/bin/bash

function report_daily(){
    clear;
    header;
    gum style "$(gum style --foreground 212 ${username}), Relatório Diário $(date '+%Y%m%d') ."
    local query_daily="select seller, total from sales where date = current_date"
    local daily_path="${integration_path}/reports/$(date "+%Y")/$(date "+%m")/$(date "+%d")"
    [ -d "${daily_path}" ] || mkdir -p "${daily_path}"
    local daily_csv="${daily_path}/$(date "+%d%m%Y").csv"
    sqlite3 "${resources_db_database}" -header -csv "${query_daily}" > "${daily_csv}"
    ${resources_report_binary} ${daily_csv}
}

function report_week(){
    clear;
    header;
    local first_day_week=$(date -d "last sunday" +%Y%m%d)
    local last_day_week=$(date -d "next saturday" +%Y%m%d)
    gum style "$(gum style --foreground 212 ${username}), Relatório Semanal de ${first_day_week} até ${last_day_week} "
    local query_week="SELECT seller, SUM(total) as total from sales where date BETWEEN date('now', 'localtime', '-' || strftime('%w', 'now', 'localtime') || ' days') and date('now', 'localtime', '+' || (6 - strftime('%w', 'now', 'localtime')) || ' days') group by seller"
    local week_path="${integration_path}/reports/week"
    [ -d "${week_path}" ] || mkdir -p "${week_path}"
    local week_csv="${week_path}/${first_day_week}_${last_day_week}.csv"
    sqlite3 "${resources_db_database}" -header -csv "${query_week}" > "${week_csv}"
    ${resources_report_binary} ${week_csv}
}
