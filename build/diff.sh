#!/bin/bash


file1=$1
file2=$2

lines=`cat $file1 | wc -l`

ret=0

for ((i=1;i<=$lines;i++))
do
  line1=`awk 'NR=="'$i'"{print $0}' $file1`
  line2=`awk 'NR=="'$i'"{print $0}' $file2`

  if [[ $line1 != $line2 ]]
  then
    echo "file: &$file1 &$file2 not equal"
    ret=1
    break
  fi
done

exit $ret


