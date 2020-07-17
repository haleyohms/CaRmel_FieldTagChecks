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





There is an ***example*** folder that contain all files needed to perform a test of the scripts.

```
\---example
	|
    +---SiteORFID
    |   +---archive
    |   \---downloads
    |           BGS_Dec3
	|			RSC_July9
    |
    +---SiteBiomark
	|   +---archive
    |   \---downloads
    |           01_00006
```

***An important note on site names:*** 
Site names are not consistenly included in the raw data files for either ORFID or Biomark. 
As a result, we assign the `site` field in the compiled data based on the names in the file structures.

For ORFID data, `site` is the name preceeding the underscore of each raw data file. 
In the example above, `site` in the compiled data is BGS.

For Biomark data, `site` is the name of the data folder. In the example above, `site` in the compiled data is SiteBiomark.
The reason for the difference is because when Biomark data is saved to a USB, each day is saved as a separate file with the format like the example. 
Rather than renaming all of those files, we assign `site` based on the folder name. 



### Running the program

Open the ***pit_tag_data_compile_run.r*** file in RStudio. This file is simply a helper for defining variables and 
calling the compiling program. To start, **three variables need to be defined:**

| Name | Type | Definition
| - | - | - |
| functionsPath | String, File path | The full system path to the ***pit_tag_data_compile_functions.r*** file
| dataDir | String, directory path | The full system path to the directory where the source log data exist - it should be the parent directory to all the site directories - 'sites' from the above directory structure example.
| dbDir | String, directory path | The full system path to the directory where the compiled log data base file exist or should be initially written to


Alter the variable definitions to suit your needs and then run the script.


##### About the compiled data tables

There are nine compilation data tables that may be produced, depending on your data inputs. These data tables do not have column headers, 
but you can add them with the code below. 

**logDB.csv**: this is a log file to document which data files were processed by the parser program and some details about those files. 

Here is my recommended way to open this file in RStudio with correct formatting and headers (copy and paste the code below). 

```R
#column names
logcolnames <- c("site", "manuf", "srcfile", "compdate", "tagnrow", "tagbadnrow", 
                 "metanrow_OR", "metanrow_BM", "metabadnrow", "msgnrow", "msgbadnrow", "othernrow", "totalnrow")

#read the file into R with correct column formats (see readr documentation here: https://readr.tidyverse.org/articles/readr.html)
read_csv(paste(dbDir,"/logDB.csv", sep=""), col_names=logcolnames, 
         col_types = cols(site="c", manuf="c", srcfile="c", compdate="D", 
                          tagnrow="i", tagbadnrow="i", metanrow_OR="i", metanrow_BM="i", 
                          metabadnrow="i", msgnrow="i", 
                          msgbadnrow="i", othernrow="i", totalnrow="i") )

logcolnames <- c("site", "manuf", "srcfile", "compdate", "tagnrow", "tagbadnrow", 
                 "metanrow", "metabadnrow", "msgnrow", "msgbadnrow", "othernrow", "totalnrow")
```
The fields are: 
+ `site`: the site or antenna name
+ `manuf`: the reader manufacturer (ORFID or Biomark)
+ `srcfile`: the raw PIT tag data source file path
+ `compdate`: the date this data file was compiled to the compilation files
+ `tagnrow`: the number of lines in raw data file that were good tag reads and were parsed correctly
+ `tagbadnrow`: the number of lines in raw data file that were bad tag reads and were not be parsed correctly
+ `metanrow_OR`: the number of lines in raw data file that were meta data from OregonRFID equipment and parsed correctly
+ `metanrow_OR`: the number of lines in raw data file that were meta data from Biomark 1S1001 standalone reader and parsed correctly
+ `metabadnrow`: the number of lines in raw data file that were bad meta data and were not be parsed correctly
+ `msgnrow`: the number of lines in raw data file that are good messages and were parsed correctly
+ `msgbadnrow`: the number of lines in raw data file that are bad tag reads and could not be parsed correctly
+ `othernrow`: the number of lines in raw data file that could not be parsed into either a tag, metadata or message 
+ `totalnrow`: the total number of lines in the raw data file
  
