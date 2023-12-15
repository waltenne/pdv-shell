#!/bin/bash

function sell_products() {
  clear;
  header;
  gum style "$(gum style --foreground 212 ${username}), escolha um produto!"
  declare -A sales_items 
  local total_sales=0

  while true;
  do
    local query_products="SELECT id, name, price, quantity FROM products"
    local data_raw=$(sqlite3 "${resources_db_database}" -header --column -separator ';' "${query_products}")

    [[ -d "${resources_invoices_path}" ]]  || mkdir -p "${resources_invoices_path}"
    [[ ! -n "${data_raw}" ]] && gum spin -s minidot --title.foreground 1 --title "Não foi identificado produtos cadastrados, por favor realize o cadastro, recarregando menu..." -- sleep 4 && menu_main
   
    local product_data=$( gum table --separator=";" <<< "${data_raw}" )
    local product_id=$(echo "${product_data}" | awk '{print $1}')
    local product_data_query="SELECT * FROM products WHERE id='${product_id}'"
    local product_data=$(sqlite3 "${resources_db_database}" -csv -separator ';' "${product_data_query}")
    local product_name=$( echo "${product_data}" | cut -d ';' -f2 )
    local product_quantity=$(echo "${product_data}" | cut -d ';' -f3 )
    local product_price=$(echo "${product_data}"  | cut -d ';' -f4 )
    local sales_quantity=$(gum input --prompt "Quantidade: " --placeholder " Qual a quantidade para venda?" --prompt.foreground 99 --cursor.foreground 99 --width 50)
    if [[ "${sales_quantity}" -gt "${product_quantity}" ]]; then
      local sales_quantity=$(gum input --prompt "Quantidade: " --placeholder " Estoque insuficiente, digite uma quantidade menor" --prompt.foreground 99 --cursor.foreground 99 --width 50)
    fi
    local sales_total=$(bc <<< "${product_price} * ${sales_quantity}")
    
    sales_items["${product_name}"]="${product_id};${product_name};${sales_quantity};${product_price}"
    gum confirm "Adicionar mais produtos?" --affirmative="SIM" --negative="NAO"

    if [[ $? -ne 0 ]]; then
      break
    fi

  done

  clear

  echo "_________________________"
  echo "Extrato de Vendas:"
  echo "_________________________"

  for product_name in "${!sales_items[@]}";
  do

    local invoice_product_quantity=$( echo "${sales_items[${product_name}]}"  | cut -d ';' -f3 )
    local total_price=$( echo  "${sales_items[${product_name}]}" | cut -d ';' -f4 )
    
    echo "[Produto] ${product_name} [Quantidade] ${invoice_product_quantity} [Valor] ${total_price}"
  done

  echo "_________________________"
  echo "Valor Total: $sales_total"
  echo "_________________________"


  gum spin -s minidot --title.foreground 2 --title "Por favor aguarde..." -- sleep 4 && clear;
  header;

  gum confirm "Deseja Finalizar a venda?" --affirmative="SIM" --negative="NAO"

  if [[ $? -ne 0 ]]; then
    gum spin -s minidot --title.foreground 2 --title "Por favor aguarde..." -- sleep 2
  else

    for product_name in "${!sales_items[@]}";
    do
      local sale_date=$(date "+%Y-%m-%d")
      local invoice_product_quantity=$( echo "${sales_items[${product_name}]}" | cut -d ';' -f3 )
      local product_id=$( echo "${sales_items[${product_name}]}" | cut -d ';' -f1 )
      local query_insert_sales="INSERT INTO sales (seller, date, total) VALUES ('${username}', '${sale_date}', ${sales_total})"
      local query_update_product="UPDATE products SET quantity = quantity - ${invoice_product_quantity} WHERE id='${product_id}';"
      local query_rm_product="DELETE FROM products WHERE id="${product_id}";"
      local query_quantity_product="SELECT quantity FROM products WHERE id='${product_id}';"
      local db_quantity_product=$(sqlite3 "${resources_db_database}" "${query_quantity_product}")

      if [[ "${invoice_product_quantity}" -eq "${db_quantity_product}" ]];
      then
          sqlite3 "${resources_db_database}" "${query_rm_product}"
      elif [[ "${invoice_product_quantity}" -lt "${db_quantity_product}" ]];
      then
          sqlite3 "${resources_db_database}" "${query_update_product}"
          sqlite3 "${resources_db_database}" "${query_insert_sales}"
      else
          gum spin -s minidot --title.foreground 1 --title "Falha no processo, por favor aguarde..." -- sleep 1 && sell_products
      fi

    done

    gum spin -s minidot --title.foreground 2 --title "Venda Concluída, por favor aguarde..." -- sleep 2

  fi

  products=()
  rates=()
  quantities=()

  # Loop through sales_items to populate the arrays
  for item in "${sales_items[@]}"; do
      IFS=';' read -r id product quantity rate <<< "$item"
      products+=( "${product}" )
      rates+=( "${rate}" )
      quantities+=( "${quantity}" )
  done

  json_items=$(jq -n \
      --argjson products "$(printf '%s\n' "${products[@]}" | jq -nR '[inputs]')" \
      --argjson rates "$(printf '%s\n' "${rates[@]}" | jq -nR '[inputs]' | sed 's/"//g')" \
      --argjson quantities "$(printf '%s\n' "${quantities[@]}" | jq -nR '[inputs]' | sed 's/"//g')" \
      '{ "items": $products, "quantities": $quantities, "rates": $rates }')

  local order_id="SELECT max(id) FROM sales"
  local order_id_raw=$(sqlite3 "${resources_db_database}" "${order_id}")

  if [ ! -n "${order_id_raw}" ]; then
      local order_id_raw="1"
  fi

  order_json="${resources_invoices_path}/${order_id_raw}.json"
  order_pdf="${resources_invoices_path}/${order_id_raw}.pdf"

  jq --argjson items "${json_items}" '. += $items' "${resources_invoice_json_template}" > "${order_json}"

  gum confirm "Identificar Cliente?" --affirmative="SIM" --negative="NAO"

  if [[ $? -ne 0 ]]; then
    gum spin -s minidot --title.foreground 3 --title "Cliente nao será indentificado..." -- sleep 2
  else
    local client_name="$(gum input --prompt "Nome: " --placeholder " Qual o nome do cliente?" --prompt.foreground 99 --cursor.foreground 99 --width 50)"
  fi

  sed -i "s/Cliente Não Identificado./${client_name}/g" "${order_json}"
  
  "${resources_invoice_binary}" generate --id "ORDER-${order_id_raw}" --import "${order_json}" --output "${order_pdf}"

  gum confirm "Enviar Email?" --affirmative="SIM" --negative="NAO"

  if [[ $? -ne 0 ]]; 
  then
    gum spin -s minidot --title.foreground 2 --title "Gerado invoice ${order_pdf}, voltando ao menu..." -- sleep 1 && main
  else
    local client_email=$(gum input --prompt "Email: " --placeholder " Qual é o email do destinatário?" --prompt.foreground 99 --cursor.foreground 99 --width )
    ${resources_email_binary} "${order_pdf}" "${client_email}"
  fi

}

