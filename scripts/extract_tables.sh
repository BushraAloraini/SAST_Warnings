#!/bin/bash

# the script is to extract lines and modified
# tables that trace all lines of code in
# a repository between two versions


WDIR=$(pwd) 
repository_list="repository_list.csv"

while read line
do
    repository=$( cut -d',' -f1 <<< "$line")
    echo "working on repository:  $repository"
    tracing_directory="$WDIR/$result_directory/\
    $repository/tracing_directory"

    lines_table="$tracing_directory/lines.csv"
    modified_table="$tracing_directory/modified.csv"
    matching_database="$tracing_directory/mei.db"
    sqlite3 "$matching_database" "SELECT * FROM lines;" > $lines_table
    sqlite3 "$matching_database" "SELECT * FROM modified;" > $modified_table
done < $repository_list
 
