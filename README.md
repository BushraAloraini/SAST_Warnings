# SATs
The results of tracing bugs in two versions of Git project (1.5.6 and 2.13.2). 

Here are the table fields that follow this order: 
project: project name
v1:  first version analyzed
v2: second version analyzed
 
tool: static analysis tool's name
old_file: original file name
old_line: original line number
old_description: original bug description
new_file: recent file name
new_line: recent line number
new_description: recent bug description [ * Note: this has value only if still_bug=1, otherwise this will be NA]
 
status: the status of the code line, and it has 4 values [exact, moved, changed, deleted]
exact: the line number has not changed 
moved: the line number has moved 
changed: the line of code has changed and modified
deleted:  the line has been deleted 
file_name_changed: a value to indicate whether the file name has changed in the recent version [0=No, 1=Yes, “removed” = to indicate that the entire file has been removed)]

still_bug: a value to indicate whether the bug report still appear in the recent version [0=No , 1=Yes ,NA= for some cases where this does not apply such as “deleted” lines]
 
same_description: a value to indicate whether the bug report still have the same description in the recent version [0=No , 1=Yes ] [ * Note: this has value only if still_bug=1, otherwise this will be NA ]
false_positive: FFP1, FFP2, TFP
TFP: if still_bug = 1 and same_description =1
FFP1: if still_bug = 1 and same_description =0
FFP2: otherwise



 ## Some initial results:
 
| Tool                           |                   TFP     |        FFP1     |       FFP2 |
| -------------------------------|---------------------------|-----------------|------------|
| Clang                          |                   6       |        0        |         76 |
| Cppcheck                       |              4             |      0          |          35 |
| Polyspace Bug Finder           |      98             |     0  |                  356 |
| PVS-Studio                      |           107        |        6       |             248|
  
