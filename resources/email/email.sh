#!/bin/bash

function sendEmail(){
    local config_file="${resources_email_path}/email-cfg"
    local email_attach=$1
    local email_dest=$2
    local email_body=$(cat ${resources_email_template} )
    local username=$( jq -r .username "$config_file" | sed "s/STORE/${store_name,,}/g" )
    local username_aut=$( jq -r .username_aut "$config_file")
    local smtp_host=$( jq -r .smtp_host "$config_file")
    local password=$( jq -r .password "$config_file")
    local subject="[${store_name^}] Invoice $( echo ${email_attach} | cut -d "./" -f1 )"
    ${resources_email_sendmail} -v -f "${username}" -s "${smtp_host}" -xu "${username_aut}" -xp "${password}" -t "${email_dest}" -o tls=no message-charset=UTF-8 message-content-type=html -u "${subject}" -m "${email_body}" -a "${email_attach}"

}