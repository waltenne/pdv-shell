#!/bin/bash

function add_user(){
    clear;
    header;
    gum style "$(gum style --foreground 212 ${username}), cadastro de Usuários!"
    local username=$(gum input --prompt "Username: " --placeholder " Informe o nome do usuario" --prompt.foreground 99 --cursor.foreground 99 --width 50)
    local password=$(gum input --prompt "Senha: " --password --placeholder " Qual a senha?" --prompt.foreground 99 --cursor.foreground 99 --width 50)
    local hashed_password=$( ${resources_util_module}/encode.sh ${password} )
    local user_query="INSERT INTO users (username, password) VALUES ('${username}', '${hashed_password}');"
    sqlite3 ${resources_db_database} << END
    ${user_query}
END
    gum spin -s minidot --title "Usuario Cadastrado com sucesso, por favor aguarde..." -- sleep 1 && login
}

function login(){
    clear;
    header;
    username=$(gum input --prompt "Username: " --placeholder " Informe o nome do usuario" --prompt.foreground 3 --cursor.foreground 3 --width 50)

    [[ ! -n "${username}" ]] && gum spin -s minidot --title.foreground 1 --title "Campo usuário não pode ficar em branco, recarregando..." -- sleep 1 && login

    local password=$(gum input --password --prompt "Senha: " --placeholder " Qual a senha?" --prompt.foreground 3 --cursor.foreground 3 --width 50)

    [[ ! -n "${password}" ]] && gum spin -s minidot --title.foreground 1 --title "Campo senha não pode ficar em branco, recarregando..." -- sleep 1 && login


    if [[ ! -n "${username}" && ! -n "${password}" ]];
    then
        gum spin -s minidot --title.foreground 1 --title "Campo usuário não pode ficar em branco, recarregando..." -- sleep 1 && login
    else
        local user_query="SELECT password FROM users WHERE username='${username}'"
        local password_hash=$( sqlite3 "${resources_db_database}" "${user_query}" )
        if [[ ! -n "${password_hash}" ]];
        then
            gum spin -s minidot --title.foreground 1 --title "Usuario ou Senha Invalidos, por favor digite corretamente..." -- sleep 2 && login
        else
            local hashed_password=$( ${resources_util_module}/decode.sh ${password_hash} )
        fi
    fi
    
    if [[ "${password}" == "${hashed_password}" ]]; then

        if [[ ! -n "${username}" ]];
        then
            gum spin -s minidot --title.foreground 1 --title "Campo usuário não pode ficar em branco, recarregando..." -- sleep 1 && login
        else
            local query_check_admin="SELECT is_admin FROM users WHERE username='${username}'"
            local check_admin=$( sqlite3 "${resources_db_database}" "${query_check_admin}" )
        fi


        if [[ "${check_admin}" == "0" ]];
        then
            gum spin -s minidot --title.foreground 2 --title "Logado com sucesso, por favor aguarde..." -- sleep 2 && menu_main
        elif [[ "${check_admin}" == "1" ]];
        then
            gum spin -s minidot --title.foreground 2 --title "Logado com sucesso, por favor aguarde..." -- sleep 2 && menu_main
        else
            gum spin -s minidot --title.foreground 1 --title "Falha no login, por favor aguarde..." -- sleep 1 && login
        fi

    else
        gum spin -s minidot --title.foreground 1 --title "Usuario ou Senha Invalidos, por favor digite corretamente..." -- sleep 2 && login
    fi
}