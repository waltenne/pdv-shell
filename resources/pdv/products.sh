#!/bin/bash

function add_product(){
  clear;
  header;
  local product_name=$(gum input --prompt "Nome Produto: " --placeholder " Informe o nome do Produto." --prompt.foreground 99 --cursor.foreground 99 --width 50)
  local product_quantity=$(gum input --prompt "Quantidade: " --placeholder " Qual a quantidade em estoque?" --prompt.foreground 99 --cursor.foreground 99 --width 50)
  local product_price=$(gum input --prompt "Preço: " --placeholder " Qual vai ser o preço?" --prompt.foreground 99 --cursor.foreground 99 --width 50)
  local query_check_product_exist="SELECT * FROM products WHERE name = '$( echo ${product_name} | tr '[:lower:]' '[:upper:]' )';"
  local query_update_product="UPDATE products SET quantity = quantity + ${product_quantity} WHERE name = '$( echo ${product_name} | tr '[:lower:]' '[:upper:]' )';"
  local query_add_product="INSERT INTO products (name, quantity, price) VALUES ('$( echo ${product_name} | tr '[:lower:]' '[:upper:]' )', ${product_quantity}, ${product_price});"
  local product_exist=$( sqlite3 "${resources_db_database}" "${query_check_product_exist}" )
  if [[ ! -n "${product_exist}" ]];
  then
      sqlite3 "${resources_db_database}" "${query_add_product}"
      gum spin -s minidot --title.foreground 2  --title "Produto $( echo ${product_name} | tr '[:lower:]' '[:upper:]' ) cadastrado com sucesso, por favor aguarde..." -- sleep 1 && menu_products
  else
      sqlite3 "${resources_db_database}" "${query_update_product}"
      gum spin -s minidot --title.foreground 2  --title "Produto $( echo ${product_name} | tr '[:lower:]' '[:upper:]' ) já existe, a quantidade em estoque foi atualizada, por favor aguarde..." -- sleep 1 && menu_products
  fi
  gum spin -s minidot --title.foreground 2  --title "Produto cadastrado com sucesso, por favor aguarde..." -- sleep 1 && menu_products
}

function rm_product() {
  clear;
  header;
  local query_products="SELECT id,name,quantity FROM products"
  local data_raw=$( sqlite3 "${resources_db_database}" -header -column "${query_products}" )
  local product_data=$( gum table <<< "${data_raw}" )
  local product_id=$( echo ${product_data} | awk '{print $1}' )
  local query_rm_product="DELETE FROM products WHERE id="${product_id}";"
  sqlite3 "${resources_db_database}" "${query_rm_product}"
  gum spin -s minidot --title.foreground 2  --title "Produto removido com sucesso, por favor aguarde..." -- sleep 1 && menu_products
}

function check_stock() {
  clear;
  header;
  local query_products="SELECT * FROM products"
  local data_raw=$( sqlite3 "${resources_db_database}" -header -column "${query_products}" )
  local product_data=$( gum table <<< "${data_raw}" )

  [[ ! -n "${data_raw}" ]] && gum spin -s minidot --title.foreground 1 --title "Não foi identificado produtos cadastrados, por favor realize o cadastro, recarregando menu..." -- sleep 4 && menu_main

  gum spin -s minidot --title.foreground 2  --title "Recarregando menu, por favor aguarde..." -- sleep 1 && menu_products
}
