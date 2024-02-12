#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}"  https://r89xg1nxpf.execute-api.us-east-1.amazonaws.com/Prod/todos)

echo "Validar si la url es valida"
echo $status_code
if [ $status_code = 200 ]
then
    echo "URL correcta"
else
    echo "La url no es correcta"
    exit 1
fi
