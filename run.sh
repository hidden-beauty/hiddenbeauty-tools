#!/bin/bash

if [ "$1" = "build" ]
then
    docker build -f Dockerfile -t hiddenbeauty:tools .
    exit
fi

if [ "$1" = "up" ]
then
    if [ -z "$2" ]
    then
        docker run -d --rm --name hb-tools -v `pwd`:/code/hb hiddenbeauty:tools python3 hiddenbeauty/fussy_is_forever.py
    else
        DIR=$2
        DIR="${DIR/#\~/$HOME}"
        docker run -d --rm --name hb-tools -v "$DIR":/archive -v `pwd`:/code/hb hiddenbeauty:tools python3 hiddenbeauty/fussy_is_forever.py
    fi
    exit
fi

if [ "$1" = "down" ]
then
    docker rm -f hb-tools
    exit
fi

docker exec -it hb-tools python3 $@
if [ "$?" -eq 137 ]; then
    echo "Error: Container aborted. Out of memory?"
    exit
fi
