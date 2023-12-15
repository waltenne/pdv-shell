#!/bin/bash

# Variavel responsavel por determinar o path root do projeto
WORKDIR=$(realpath `dirname $0`)

# Importação dos modulos
source ${WORKDIR}/resources/sqlite3/database.sh
source ${WORKDIR}/resources/pdv/main.sh
source ${WORKDIR}/resources/pdv/products.sh
source ${WORKDIR}/resources/pdv/report.sh
source ${WORKDIR}/resources/pdv/sales.sh
source ${WORKDIR}/resources/pdv/users.sh
source ${WORKDIR}/resources/util/util.sh
source ${WORKDIR}/resources/email/email.sh

create_product_table;
create_sales_table;
create_user_table;
check_dependences;
login;