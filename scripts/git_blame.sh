#!/bin/bash
#
#  This script is to extract the changes of the line of code
#  that happen between two versions and save the results into
#  the whole commits logs is saved to "git_blame_output" file,
#  while the the altered commit and dates data along with
#  other info is saved into "FFP_warnings_decay.csv" file
#

WDIR=$(pwd)
repository_list="repository_list.csv"
fpp_warnings_list="FFP_warnings.csv"
list="FFP_altered_lines.csv"
output="git_blame_output"
output_file="FFP_warnings_decay.csv"


c=1

set -f
while read line
do
        line=$(echo $line | tr -d '\r'|  awk '{$1=$1}1')

        repository=$( cut -d',' -f1 <<< "$line")
        get_line=$(grep "$repository" $repository_list)

        new_commit=$( cut -d',' -f3 <<< "$get_line")
        old_commit=$( cut -d',' -f5 <<< "$get_line")
        new_date=$( cut -d',' -f2 <<< "$get_line")
        old_date=$( cut -d',' -f4 <<< "$get_line")

        orignal_commit="$new_commit"

        echo "c=$c" >> c

        path="$WDIR/repository_directory/$repository"
        echo "" >> $output
        echo "#####################################################################" >> $output
        echo "working on repo:  $repository"
        echo "Results for repo:  $repository" >> $output
        date_o=$(date -j -f "%d-%b-%Y" "$old_date" +"%s")

        cd $path

        git checkout -f "$orignal_commit"
        echo "Commit status of  $orignal_commit:" >> $output
        git show  -s "$orignal_commit"  >> $output
        echo "" >> $output

        altering_commit=""
        altering_date=""
        bug_line="$line"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $output
        echo " working on bug: $bug_line" >> $output

        part0=$(cut -d',' -f1-5 <<< $bug_line)
        part1=$(grep "$part0," $fpp_warnings_list)
        echo "The lines including bugs are:" >> $output
        echo "$part1">> $output
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $output
        echo "" >> $output
        echo "" >> $output

        lines_n=$(cut -d',' -f6 <<< $bug_line)
        n=$( grep -o ":" <<< $lines_n | wc -l)
        file_path=$(echo $bug_line | cut -d',' -f5  | awk '{$1=$1}1')
        old_file=$(echo $bug_line | cut -d',' -f3  | awk '{$1=$1}1')
        if [[ -z "$file_path"  ]]; then
            file_path="$old_file"
        fi

        file_order=$( echo "$file_path" | awk -F'/' '{ print NF }')
        file=$(echo "$file_path" | cut -d'/' -f"$file_order")
        file_path=$(find . -xdev -name "$file")

        for (( j=1 ; j <= $n ; j++))
        do
            git checkout -f "$orignal_commit"
            new_commit1="$orignal_commit"

            line_num=$(echo $lines_n | cut -d':' -f$j |  awk '{$1=$1}1')
            end_of_blame=0
            still_updated_date=""
            updated_date=""

            while [[ $end_of_blame -eq 0 ]]
            do
                    new_commit2=""
                    still_updated_date="$updated_date"
                    git checkout -f "$new_commit1"
                    blame=$(git blame -l -e -w -L ${line_num},${line_num} -f -n  -t $file_path)
                    echo ""
                    echo "" >> $output
                    echo " working on blame: $blame"
                    echo "working on blame: $blame" >> $output
                    new_commit2=$(cut -d' ' -f1 <<<  $blame)
                    new_commit2=$(echo "$new_commit2" | sed 's/\^//')
                    file_path=$(cut -d' ' -f2 <<<  $blame)
                    line_num=$(cut -d' ' -f3 <<<  $blame)
                    updated_date=$(cut -d' ' -f5 <<<  $blame)
                    echo "Commit message of $new_commit2" >> $output
                    git show -s "$new_commit2"  >> $output
                    date_u=$(date -j -f "%s" "$updated_date" +"%s")
                    echo "" >> $output
                    echo  "Commit diff status of $new_commit1 && $new_commit2:" >> $output
                    git diff $new_commit2 $new_commit1 $file_path  >> $output
                    echo "" >> $output
                    echo "" >> $output

                    if [ $date_u -le $date_o ] || [ "$still_updated_date" ==  "$updated_date" ] ;
                    then
                        altering_commit="$altering_commit $new_commit2"
                        altering_date="$altering_date $updated_date"
                        end_of_blame=1
                    fi
                    new_commit1="$new_commit2"

             done
        done
        echo "$line, $altering_commit, $altering_date" >> $output_file
        cd $WDIR
        c=$((c+1))


done < $list
set +f

