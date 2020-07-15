#!/bin/bash

counter=$(ps -ef | grep apache2 | wc -l)
while [ $counter -gt 1 ]
do
#    echo "servidor apache2 activo";
    sleep 1m;
	counter=$(ps -ef | grep apache2 | wc -l)
done

