
# hit_tracing fields are: 


**project**: project name

**old_version**: the first version analyzed

**new_version**: the second version analyzed
 
**tool**: static analysis tool's name

**old_file:** original file name

**old_line**: original line number

**old_description**: original bug description

**new_file**: recent file name

**new_line**: recent line number

**new_description**: recent bug description [ * Note: this has value only if still_bug=1, otherwise this will be NA]
 
**line_status**: the status of the line and it has 4 values [Constant, Moved, Altered, Deleted]
- Constant: the line of code has not been altered and the line number has not been changed 
- Moved: the line of code has not been altered but the line number has been moved 
- Altered: the line of code has been altered
- deleted: the line of code has been deleted 

**file_status**: a value to indicate whether the file name has changed in the recent version and it has 2 values  [ Changed, Constant]
- Changed: the file name has been modified  
- Constant: the file name still the same

**still_bug**: a value to indicate whether the bug  still appears in the recent version of the bug report and it has 3 values [No, Yes, NA]
- Yes: the bug appears in the recent bug report
- No: the bug does not appear in the recent bug report
- NA: in some cases such as when the line of code has been deleted, so the field holds this undefined value
 
**description_status**: a value to indicate whether the bug report still have the same description in the recent version and it has 3 values [ Constant, Changed, NA] 
- Constant: the bug appears in the recent bug report and it holds the smae old bug description
- Changed: the bug appears in the recent bug report but the it h different description
- NA: in some cases such as when the line of code has been deleted, so the field holds this undefined value
 

**false_positive**: FFP1, FFP2, FFP3, TFP
- TFP: it means that the bug report is actually false positive, and this happens when the fields hold these values [still_bug=Yes and description_status=Constant].
- FFP1: it means that the bug was reported in the recent version but with different description, and this happens when the fields hold these values [still_bug=Yes and description_status=Changed].
- FFP2: when the bug has not appear in the recent version and the line of code still presents.
- FFP3:if the line of code has been deleted in recent version.
