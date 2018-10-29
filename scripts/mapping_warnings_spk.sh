#!/bin/bash
#
# This script is to map all SATs warnings into the
# the Seven Pernicious Kingdoms (SPKs) classification
#  and save the output into "FFP_warnings.csv" file.
#
#
 


WDIR=$(pwd)

tracing_list="FFP_warnings_initial.csv"
class_file="SPKclassification_SATwarnings.csv"
output="FFP_warnings.csv"
c=1

set -f
while read line
do
    echo $c
    tool=$(echo $line  | awk -F "," '{ print $1 }' | tr -d '\r'|  awk '{$1=$1}1')
    type=$(echo $line  | awk -F "," '{ print $2 }'| tr -d '\r'|  awk '{$1=$1}1')
    class=$(echo $line | cut -d',' -f3- | tr -d '\r'|  awk '{$1=$1}1' )

    awk -F"," -v i="$tool" -v j="$type" '{if($4 == i && $7 == j) {print $0" ,"$class }' $tracing_list >> $output

    c=$((c+1))
done < $class_file
set +f




