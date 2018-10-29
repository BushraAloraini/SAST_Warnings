
# An empirical study of security warnings from static analysis tools
The repository contains the raw data and a set of scripts that used the study, which could help to replicate this study. Static analysis tools are available for downloading, as well as code and list of repositories of the analyzed projects. The expermintal desgin  is detailed in the paper in Section 5. 

# Working_directory
This directory shows the structre that was used in the scripts to store the results, the structure is as follow:

.
├── repository_directory
├── repository_list.csv
├── repository_metrics.csv
└── result_directory
    └── parent_directory
        └── child_directory
            ├── commits_history
            │   └── all_commits_patches
            ├── report_directory
            │   ├── hit_list_for_checkpoint_1
            │   ├── hit_list_for_checkpoint_1_no_test
            │   ├── hit_list_for_checkpoint_1_only_c
            │   ├── hit_list_for_checkpoint_2
            │   ├── hit_list_for_checkpoint_2_no_test
            │   └── hit_list_for_checkpoint_2_only_c
            ├── tmp
            │   ├── clang_analysis_result-1
            │   ├── clang_analysis_result-2
            │   ├── cppcheck_analysis_result-1
            │   ├── cppcheck_analysis_result-2
            │   ├── flawfinder_analysis_result-1
            │   ├── flawfinder_analysis_result-2
            │   ├── parasoft_analysis_result-1
            │   ├── parasoft_analysis_result-2
            │   ├── pvs-studio_analysis_result-1
            │   ├── pvs-studio_analysis_result-2
            │   ├── rats_analysis_result-1
            │   └── rats_analysis_result-2
            └── tracing_directory
                ├── lines.csv
                └── modified.csv

