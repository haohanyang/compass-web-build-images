#/bin/bash

timeout 30s docker run --rm $1

if [ $? -eq 124 ]; then
    echo "ok"
else
    exit 1
fi