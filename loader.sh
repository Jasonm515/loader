#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

OUTPUT_FILE="$1"


tail -F "$OUTPUT_FILE" | while read -r line; do

    if echo "$line" | grep -qE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ([^:]+):(.+)'; then
        IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
        PORT=$(echo "$line" | grep -oE ':[0-9]+' | head -n 1 | tr -d ':')
        USERNAME=$(echo "$line" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ([^:]+)' | awk '{print $3}')
        PASSWORD=$(echo "$line" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ([^:]+):(.+)' | awk '{print $4}')


        echo "Parsed Info:"
        echo "IP: $IP"
        echo "Port: $PORT"
        echo "Username: $USERNAME"
        echo "Password: $PASSWORD"
        echo "---------------------"
        echo "start" | nc -w 1 $IP 1234
     fi
done
