#!/bin/bash

# URL del endpoint
URL="https://crudcrud.com/api/e1d4ad6e26f24811b7be2720f70108a8/noticias"

# Contador de intentos
attempts=0

echo "Comenzando pruebas al endpoint: $URL"

while true; do
  # Incrementar contador
  ((attempts++))
  
  # Realizar la petición y capturar código de estado HTTP
  status_code=$(curl -s -o /dev/null -w "%{http_code}" $URL)
  
  # Mostrar resultado del intento
  echo "Intento $attempts: Código de estado HTTP: $status_code"
  
  # Verificar si el código es un error 4xx
  if [[ $status_code -ge 400 && $status_code -lt 500 ]]; then
    echo "¡Error 4xx detectado después de $attempts intentos!"
    echo "El endpoint ya no está disponible (Código: $status_code)"
    break
  fi
 
  sleep 0.5
done