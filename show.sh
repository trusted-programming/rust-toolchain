#!/bin/bash

#cat workplace/cargo-profiler-callgrind.txt | while read line
a1="[32m"
a2="^[[0m"
b=""
echo $1
sed -i "s/$a1/$b/g" $1
sed -i "s/$a2/$b/g" $1
cat $1 | while read line
do
	echo $line
done
