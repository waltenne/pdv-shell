#!/bin/bash

# Variavel responsavel por determinar o path root do projeto
WORKDIR=$(realpath `dirname $0`)

# Importação dos modulos
source ${WORKDIR}/resources/sqlite3/database
source ${WORKDIR}/resources/pdv/main
source ${WORKDIR}/resources/pdv/products
source ${WORKDIR}/resources/pdv/report
source ${WORKDIR}/resources/pdv/sales
source ${WORKDIR}/resources/pdv/users
source ${WORKDIR}/resources/util/util
source ${WORKDIR}/resources/email/email

create_product_table;
create_sales_table;
create_user_table;
check_dependences;
login;