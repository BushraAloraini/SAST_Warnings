#!/bin/bash  -e
#
#  This script is to extract all the CVE-ID from
#  "all_commits_patches" file that includes log messages
#  and save the output into "repository_cve" file
#  that includes the repository name along with the CVE-ID
#
# 


WDIR=$(pwd)
repository_list="repository_list.csv"
output="repository_cve.csv"

while read repo
do
    repository=$( cut -d',' -f1 <<< "$repo")
    echo "working on repo: $repository"
    path="$WDIR/$result_directory/$repository/commits_history"
    commits_patches="$path/all_commits_patches"

    cve_file="$path/cve_file"
    cd $path
    cve=""
    cve=$(grep -o  'CVE-....-....' $commits_patches)
    echo "${cve[@]}" >> $cve_file

    while read cve
    do
        repository=$(echo "$repository, $cve") >> $output
    done < $cve_file

    rm $cve_file
    cd $WDIR
done < $repository_list

