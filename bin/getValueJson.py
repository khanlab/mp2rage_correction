#!/usr/bin/python

# import modules
import os
import sys
import json


if len(sys.argv) < 3:
	print('Usage: '+sys.argv[0]+' <in_json> <key name> <optional keys if nested ...>')
	exit(1)
 

in_file=sys.argv[1]
key=sys.argv[2]





with open(in_file) as data_file:
	data = json.load(data_file)
	val=data[key]
	for i in range(3,len(sys.argv)):
		key=sys.argv[i]
		val=val[key]

	print(val)
