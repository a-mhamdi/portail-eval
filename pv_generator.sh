#!/usr/bin/bash

## SYNTAX: ./pv_generator.sh cin

if [[ ! -d dir_pv/$1 ]]
	then
		mkdir -p dir_pv/$1
fi

source .venv/bin/activate

if [[ "$1" == "" ]]
	then
		echo "ERROR: No argument supplied"
		exit 1
fi

./pv_generator.py $1

echo "GENERATING PDF FILES..."
for filename in $(ls -la dir_pv/$1 | grep .typ | awk '{print $9}');
	do
	typst compile --root . dir_pv/$1/$filename
done

echo "DONE!"
