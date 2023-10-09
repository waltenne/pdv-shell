#!/bin/bash

# Verifique se o arquivo CSV de entrada foi fornecido
if [ $# -ne 1 ]; then
  echo "Uso: $0 arquivo.csv"
  exit 1
fi

# Verifique se o arquivo CSV existe
if [ ! -f "$1" ]; then
  echo "O arquivo CSV não existe: $1"
  exit 1
fi

echo "______________________________"
echo "vendedor       total"

# Ler o arquivo CSV, separado por vírgulas, ordenar por total e calcular o total de vendas
TOTAL_VENDAS=0
data=()
max_total=0  # Inicializar a variável para rastrear o valor máximo
while IFS=, read -r seller total; do
  if [[ "$seller" == "seller" ]]; then
    continue  # Ignorar o cabeçalho
  fi
  TOTAL_VENDAS=$(echo "$TOTAL_VENDAS + $total" | bc -l)
  data+=("$seller,$total")

  # Atualizar o valor máximo, se necessário
  if (( $(bc <<< "$total > $max_total") )); then
    max_total=$total
  fi
done < <(tail -n +2 "$1" | sort -t ',' -k2 -n)

# Função para imprimir uma barra de tamanho proporcional
imprimir_barra() {
  local tamanho="$1"
  local barra="█"
  local barra_vazia="░"
  local passos=1
  local i
  local proporcao=$(bc -l <<< "$tamanho / $max_total")  # Calcular proporção
  local tamanho_barra=$(bc -l <<< "30 * $proporcao")  # Tamanho da barra proporcional

  tamanho_barra=${tamanho_barra%.*}  # Converter para um número inteiro
  for ((i = 0; i < tamanho_barra; i += passos)); do
    echo -n "$barra"
    passos=$((passos + 1))
  done
  for ((i; i < 30; i++)); do
    echo -n "$barra_vazia"
  done
  echo ""
}

# Encontre o comprimento máximo do nome do vendedor
max_length=0
for linha in "${data[@]}"; do
  IFS=',' read -r seller _ <<< "$linha"
  length=${#seller}
  if [ "$length" -gt "$max_length" ]; then
    max_length="$length"
  fi
done

# Imprimir o gráfico de barras
for linha in "${data[@]}"; do
  IFS=',' read -r seller total <<< "$linha"
  printf "%-*s %10s | " "$max_length" "$seller" "$total"
  imprimir_barra "$total"
done

# Imprimir o total de vendas
echo "______________________________"
echo "Total de vendas: $TOTAL_VENDAS"
