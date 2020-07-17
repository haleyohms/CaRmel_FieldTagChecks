# CaRmel_FieldTagCheck
This code helps you check for duplicate tags during field season.
 
Below are instructions for setting up the duplicate tag check code on 
the field laptop.
 
## Instructions

### Get the code from GitHub

To get the R code from GitHub, click the ***Clone or download button*** and select ***Download zip***. A zipped directory containing all files will be downloaded.
Unzip the directory and move the folder to a script directory on your system.

There are four files included in the GitHub download:
+ **pfield_tag_duplicate_compile_run.r**: a function file to be sourced in the ***FieldDuplicateTagCheck*** file
+ **FieldDuplicateTagCheck.r**: a file that runs the duplicate tag data compiling program  
+ **AllFishData.Rdata**: a data file that contains all previously used tag numbers
+ **Example_Scarlett_2019**: an example data file to check that the program is working


### Prepare the field laptop

+ Create a folder called `DuplicateTagChecker`
    + Within this folder place the ***field_tag_duplicate_compile_run.r*** file and the ***AllFishData.Rdat*** file
+ Create a separate folder called `PopSurveyData2020`
    + Within this folder place the ***example_pop_data.xlsx***
+ Install R, RStudio, as well as the dplyr and tidyverse packages
+ Open the ‘field_tag_duplicate_compile_run.r’ file and update the dbDir and dataDir to their locations on the laptop.
    + The dbDir is where the “DuplicateTagChecker” file is located.
    + The dataDir is where the “PopSurveyData2020” folder is located

### Test the code

+ Select all the code within ***field_tag_duplicate_compile_run.r*** `(Ctrl+A)` and run all the code (Ctrl+Enter)
+ Several things should happen:
    + `AFD`, `dupTags`, `fallpop`, `tbl`, and `Tdat` should show up in the Data of Global Environment (upper right in R studio)
 	+ The first 6 rows and 8 columns of the pop survey data should appear (this indicates those files compiled correctly)
 	+ The first 6 rows and 8 columns of the main fish data data should appear (this indicates that file compiled correctly)
 	+ Any duplicates should appear after the message “Here are the duplicates”. There should be two duplicates in the example file

### Run the code after fieldwork each day: 
+ Each day before leaving the site:
	+ Check the raw data folder to ensure that each column and row are filled 
	out completely and correctly. Check that autofill has not changed the dates 
	to sequential and that all fields have been filled in on the last rows of data.
 	+ Place the file in the `PopSurveyData2020` folder
 	+ Run the ***field_tag_duplicate_compile_run.r*** code
 	+ The first 6 rows from the pop survey data and main fish data should appear. If there are any duplicates, they will be printed at the end. If no duplicates are present, none will be printed. 
 	+ If you find duplicates, please let me know that day so we can troubleshoot why this is occurring and prevent it. 


