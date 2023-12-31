#!/bin/bash

function logo() {
cat << 'EOF'
.______    _______  ____    ____         _______. __    __   _______  __       __      
|   _  \  |       \ \   \  /   /        /       ||  |  |  | |   ____||  |     |  |     
|  |_)  | |  .--.  | \   \/   /        |   (----`|  |__|  | |  |__   |  |     |  |     
|   ___/  |  |  |  |  \      /          \   \    |   __   | |   __|  |  |     |  |     
|  |      |  '--'  |   \    /       .----)   |   |  |  |  | |  |____ |  `----.|  `----.
| _|      |_______/     \__/        |_______/    |__|  |__| |_______||_______||_______|
EOF
echo "_______________________________________________________________________________________"
echo "                                                  $(date "+%d/%m/%Y %H:%M:%S")"
echo 
}

function header(){
  gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "$(gum style --foreground 2 "$(logo)")"
}

function ctrl_c () {
    echo "Ctrl + C happened"
}

resources_root_dir="${WORKDIR}/resources"
store_name="Mercadinho Chinelão"

resources_invoice_json_template="${resources_root_dir}/util/invoice_template_data.json"
resources_integration_path="${WORKDIR}/integration"
resources_invoices_path="${resources_integration_path}/invoices/$(date "+%Y-%m-%d")"

resources_db_module="${resources_root_dir}/sqlite3"
resources_db_module_sql="${resources_db_module}/sqlite3/sql"
resources_db_database="${resources_db_module}/pdvshell.db"

resources_util_module="${resources_root_dir}/util"
resources_invoice_binary="${resources_util_module}/invoice.go"
resources_pdv_module="${resources_root_dir}/pdv"
resources_report_binary="${resources_root_dir}/report/chart.sh"

resources_email_path="${resources_root_dir}/email"
resources_email_binary="${resources_root_dir}/email/email.sh"
resources_email_sendmail="${resources_email_path}/sendEmail"
resources_email_template="${resources_email_path}/report.html"

menu_products="Menu Produtos"
menu_users="Menu Usuário"
menu_report="Menu Relatório"
menu_sales="Menu Vendas"
menu_exit="Sair"
menu_main="Voltar ao Menu Principal"

menu_product_add="Cadastro Produto"
menu_product_rm="Remover Produto"
menu_product_stock="Consultar Estoque"

menu_users_add="Cadastro Usuário"
menu_users_rm="Remover Usuário"

menu_sales_add="Realizar Venda"

menu_report_sales_diary="Relatorio Vendas Diária"
menu_report_sales_week="Relatorio Vendas Semanal"
menu_report_sales_month="Relatorio Vendas Mensal"
menu_report_sales_year="Relatorio Vendas Anual"
