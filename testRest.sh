#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}"  https://r89xg1nxpf.execute-api.us-east-1.amazonaws.com/Prod/todos)

echo "Validar si la url es valida"
echo $status_code
if [ $status_code = 200 ]
then
    echo "URL correcta"
    echo "Validar busqueda de codigo inexistente"
    status_code=$(curl -s -o /dev/null -w "%{http_code}"  https://r89xg1nxpf.execute-api.us-east-1.amazonaws.com/Prod/todos/codigo_inexistente)
    if [ $status_code = 404 ]
    then
        echo "El codigo no existe"
    else
        echo "El endpoint no funciona correctamente"
        exit 1
    fi
else
    echo "La url no es correcta"
    exit 1
fi
