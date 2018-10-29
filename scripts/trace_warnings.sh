#!/bin/bash
#
# this script is to trace lines of code that include warnings
# and check the warning status in the newer version and produce
# the false positive rates based on the following values:
# TFP: if the line of code appear intact in the newer version
#      with the old warning description
# FFP1: if the line of code is still there but with different
#       warning description  in the newer version
# FFP2: if the line of code is still there but without
#        any warning in the newer version
# FFP3: if the line of code is deleted in the newer version
#
#


WDIR=$(pwd)
repository_list="repository_list.csv"
output="FFP_warnings.csv"

echo "project, olod_version, new_version, tool, old_file, old_line,\
old_description, new_file, new_line, new_description, line_status,\
file_status, still_bug, description_status, false_positive, spilt" >>  $output

t=1
set -f

while read line
do
    repository=$( cut -d',' -f1 <<< "$line" | awk '{$1=$1}1')
    repo_parent=$( cut -d'/' -f1 <<< "$repository")
    repo_child=$( cut -d'/' -f2 <<< "$repository")
    path="$WDIR/result_directory/$repository"
    tracing_directory="$path/tracing_directory"
    report_directory="$path/report_directory"
    hit_list1="$report_directory/hit_list_for_checkpoint_1_only_c"
    hit_list2="$report_directory/hit_list_for_checkpoint_2_only_c"
    lines_table="$tracing_directory/lines.csv"
    modified_table="$tracing_directory/modified.csv"

    echo "working on repository:  $repository"
    # lines_table and modified_table are extrr4acted from
    # the database that provide tracing among versions


    new_version=$( cut -d',' -f3 <<< "$line" | awk '{$1=$1}1')
    old_version=$( cut -d',' -f5 <<< "$line" | awk '{$1=$1}1')


    old_file=""
    old_line=""
    old_description=""
    new_file=""
    new_line=""
    new_description=""
    line_status=""
    file_status=""
    still_bug=""
    description_status=""
    false_positive=""
    spilt=1

        # read all hits from the old version

    while read hit
    do
        tool=$( cut -d',' -f1 <<< "$hit")
        old_file=$(cut -d',' -f2 <<< "$hit" | awk '{$1=$1}1')
        old_line=$( cut -d',' -f3 <<< "$hit" | awk '{$1=$1}1')
        old_description=$( cut -d',' -f5 <<< "$hit" | awk '{$1=$1}1')

        # trace the lines
        the_hit=$(grep "^$old_file|$old_line|" $lines_table)
        num_hit=$(grep -c "^$old_file|$old_line|" $lines_table)

        if [ "$num_hit" -gt 0 ]; then
            # here let's see if the line has been modified or not
            is_modified=$( cut -d'|' -f5 <<< "$the_hit" | tr -d '\r' )

            # is_modified value indicates that the line of code
            # has been changed in the newer version and that
            # change may either infer line deletion or altering

            if [[ $is_modified == 1 ]]; then
                modified_hit=()
                modified_hit=$(grep "^$old_file|$old_line|" $modified_table)
                modified_hit=($modified_hit)
                modified_hit_length="${#modified_hit[@]}"

                # first step is to check if the line
                # of code that includes the warning
                #  has been deleted
                deleted="Yes"
                line_collection=()
                file_collection=()
                index=0

                # this loop is to detect if the original line has no
                # matching lines in the newer version
                for (( c=0; c<$modified_hit_length; c++ )); do
                    has_line=$( cut -d'|' -f8 <<< "${modified_hit[$c]}")
       
                    if [[ ! -z $has_line ]];then
                        deleted="No"
                        line_collection[$index]=$has_line
                        index=$((index+1))
                    fi
                done

                if [[  $deleted == "Yes" ]]; then
                    line_status="Deleted"
                    new_line="NA"
                    still_bug="NA"
                    false_positive="FFP3"
                    description_status="NA"
                    new_description="NA"
                    new_file="NA"
                    file_status="NA"
                    traced_warning=$(echo "$repository, $old_version, $new_version, $tool,\
                    $old_file, $old_line, $old_description, $new_file, $new_line,\
                    $new_description,$line_status, $file_status, $still_bug,\
                    $description_status, $false_positive, $spilt"  | tr -d '\r')
                    echo $traced_warning >>  $output
                else

                    # second step is to check if the line
                    # of code that includes the warning
                    # has been altered, note that in this
                    # case the line of code may be splitted
                    # into more than one line in the newer vresion

                    line_status="Altered"
                    # we might have more than one lines
                    # in the newer verssions and this loop
                    # is to delete repeated lines since the tool
                    # trace tokens (fine-grain)
                    line_collection=( `for i in ${line_collection[@]};\
                    do echo $i; done | sort -u` )
                    # check if this file and line has any hit in hit_list1
                    line_collection_length="${#line_collection[@]}"
                    spilt=$line_collection_length

                    for (( c=0; c<$line_collection_length; c++ )); do
                        new_line="${line_collection[$c]}"
                        new_file=$(echo "$modified_hit" |\
                        awk -F'|' -v var=$new_line '{if($8==var) {print $6}}'  )
                        new_file=$(echo $new_file | cut -d' ' -f1 | awk '{$1=$1}1')

                        if [ "${new_file}" == "${old_file}" ]; then
                            file_status="Constant"
                        else
                            file_status="Changed"
                        fi

                        look_file="$new_file,${line_collection[$c]},"
                        look_file=$(echo "$look_file" | awk '{$1=$1}1' )
                        still_hit=$(awk  -v var="$tool"  '$0 ~ var ' $hit_list1 | awk -v var="$look_file" '$0 ~ var '  | awk '{$1=$1}1' | wc -l)

                        if [[ $still_hit -gt 0 ]]; then

                            for (( i=1 ; i <= $still_hit ; i++ ))
                            do
                                    the_still_hit=$( awk  -v var="$tool" '$0 ~ var '  $hit_list1 | grep -m $i "$look_file"  | tail -1 | awk '{$1=$1}1'  )
                                    new_description=$( cut -d',' -f5 <<< "$the_still_hit" | tr -d '\r' | awk '{$1=$1}1' )
                                    still_bug="Yes"
                                    #   # extract the description
                                    if [[ "$old_description" == "$new_description" ]]; then
                                        description_status="Constant"
                                        false_positive="TFP"
                                        break
                                    else
                                        description_status="Changed"
                                        false_positive="FFP1"
                                    fi

                              done
                         else
                                    new_description="NA"
                                    description_status="NA"
                                    still_bug="No"
                                    false_positive="FFP2"
                         fi

                         traced_warning=$(echo "$repository, $old_version, $new_version, $tool, $old_file, $old_line,\
                         $old_description, $new_file, $new_line, $new_description, $line_status, $file_status,\
                         $still_bug, $description_status, $false_positive, $spilt"  | tr -d '\r')

                         echo "$traced_warning" >>  $output
                      done
                  fi

                # is_modified value of 0 indicates that the line of code
                # has not been changed in the newer version and that
                # may either infer line has moved or no change at all

             else
                new_line=$(cut -d'|' -f4 <<< "$the_hit" | awk '{$1=$1}1')
                new_file=$(cut -d'|' -f3 <<< "$the_hit" | awk '{$1=$1}1')
                new_file=$(echo "$new_file" | cut -d' ' -f1 | awk '{$1=$1}1')
                if [ "${new_file}" == "${old_file}" ]; then
                    file_status="Constant"
                else
                    file_status="Changed"
                fi
                # extract the status of the line
                if [ "$new_line" == "$old_line" ]; then
                    line_status="Constant"
                else
                    line_status="Moved"
                fi

                # check if this file and line has any hit in hit_list1
                look_file="$new_file,$new_line,"
                look_file=$(echo "$look_file" | awk '{$1=$1}1' )
                still_hit=$(awk  -v var="$tool" '$0 ~ var ' $hit_list1 | awk -v var="$look_file" '$0 ~ var '  | awk '{$1=$1}1' | wc -l)
                # extract the new description
                if [ $still_hit -gt 0 ]; then
                    for (( j=1 ; j <= $still_hit ; j++ ))
                    do
                        the_still_hit=$( awk  -v var="$tool" '$0 ~ var ' $hit_list1 | grep -m $j "$look_file"  | tail -1 |  awk '{$1=$1}1'  )
                        new_description=$(  cut -d',' -f5 <<< "$the_still_hit" | tr -d '\r' | awk '{$1=$1}1' )
                        still_bug="Yes"
                        # extract the description
                        if [[ "$old_description" == "$new_description" ]]; then
                            description_status="Constant"
                            false_positive="TFP"
                             break
                        else
                            description_status="Changed"
                            false_positive="FFP1"
                        fi

                    done
                else
                    new_description="NA"
                    description_status="NA"
                    still_bug="No"
                    false_positive="FFP2"
                fi

                traced_warning=$(echo "$repository, $old_version, $new_version,\
                $tool, $old_file, $old_line, $old_description, $new_file, $new_line,\
                $new_description, $line_status, $file_status,$still_bug,\
                $description_status, $false_positive, $spilt"  | tr -d '\r')
                echo $traced_warning >>  $output
            fi

        else
                # if we did not find the file traced by the tool
                new_file="Not traced"
                new_line="Not traced"
                new_description="Not traced"
                line_status="Not traced"
                file_status="Not traced"
                still_bug="Not traced"
                description_status="Not traced"
                false_positive="Not traced"

                traced_warning=$(echo "$repository, $old_version, $new_version,\
                $tool,$old_file, $old_line,$old_description, $new_file, $new_line,\
                $new_description, $line_status, $file_status,$still_bug,\
                $description_status, $false_positive, $spilt"  | tr -d '\r')

                echo $traced_warning >>  $output

            fi
        fi

    done < $hit_list2
done < $repository_list

set +f


