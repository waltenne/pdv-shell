#!/bin/bash

# Function to create the product table if it does not exist
function create_product_table() {
  products_sql="${resources_db_module_sql}/products.sql"
  sqlite3 ${resources_db_database} < ${products_sql}
}

# Function to create the sales table if it does not exist
function create_sales_table() {
  sales_sql="${resources_db_module_sql}/sales.sql"
  sqlite3 ${resources_db_database} < ${sales_sql}
}

# Function to create the user table if it does not exist
function create_user_table(){
  users_sql="${resources_db_module_sql}/users.sql"
  sqlite3 ${resources_db_database} < ${users_sql}
}
