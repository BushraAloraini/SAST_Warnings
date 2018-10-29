#!/bin/bash
#
# This script is to extract all repository's log messages
# that occur between two dates "d1" and "d2" that are listed
# in the "repository_list" and save the output into
# "all_commits_patches"  file for each repository.
#
#   


WDIR=$(pwd)
repository_list="repository_list.csv"

while read line
do
    repository=$( cut -d',' -f1 <<< "$line")
    d1=$( cut -d',' -f2 <<< "$line")
    d2=$( cut -d',' -f4 <<< "$line")
    repo_path="$WDIR/$repository_directory/$repository"
    output="$WDIR/$result_directory/$repository/commits_history/all_commits_patches"
    echo "Working on repository: $repository"
    cd $repo_path
    git checkout -f master
    commits_messages=""
    commits_messages=$(git log -p --since="$d2" --before="$d1")
    echo "${commits_messages[@]}" >> $output
    cd $WDIR

done < $repository_list
