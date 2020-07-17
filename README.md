# CaRmel_FieldTagCheck
This code helps you check for duplicate tags during field season.
 
Below are instructions for setting up the duplicate tag check code on 
the field laptop.
 
## Instructions

### Get the code from GitHub

To get the R code from GitHub, click the ***Clone or download button*** and select ***Download zip***. A zipped directory containing all files will be downloaded.
Unzip the directory and move the folder to a script directory on your system.

There are four files included in the GitHub download:
+ **pfield_tag_duplicate_compile_run.r**: a function file to be sourced in the *FieldDuplicateTagCheck* file
+ **FieldDuplicateTagCheck.r**: a file that runs the duplicate tag data compiling program  
+ **AllFishData.Rdata**: a data file that contains all previously used tag numbers
+ **Example_Scarlett_2019**: an example data file to check that the program is working


#### Prepare the field laptop

<ol>
  <li>Coffee</li>
  <li>Tea</li>
  <li>Milk</li>
</ol>

<ol>
<li>Create a folder called `DuplicateTagChecker`</li>
	<ol>
		<li>Within this folder place the ***field_tag_duplicate_compile_run.r*** file and the ***AllFishData.Rdat*** file</li>
	</ol>
<li>Create a separate folder called `PopSurveyData2020`</li>
	<ol>
		<li>Within this folder place the ***example_pop_data.xlsx***</li>
	</ol>
<li>Install R, RStudio, as well as the dplyr and tidyverse packages</li>
<li>Open the ‘field_tag_duplicate_compile_run.r’ file and update the dbDir and dataDir to their locations on the laptop.</li>
	<ol>	
		<li>The dbDir is where the “DuplicateTagChecker” file is located.</li> 
		<li>The dataDir is where the “PopSurveyData2020” folder is located</li>
	</ol>
</ol>




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
  
**tagDB.csv**: these are successful tag readings where data acquired from the reader is formatted correctly. 
For ORFID data, only tags that are numeric and have the prefixes "000", "900", "982", "985", and "999" will make it into tagdb.
All other tag lines (including hexadecimal formatted tags) will go to the tagbadDB. 

There are fewer conditions on tags that go to tagDB for Biomark data. Both decimal and hexadecimal (i.e., both numeric and alpha characters) 
are allowed and there are no prefix conditions. Any non-alpha or numeric characters in the tag will go to tagBadDB. 


Here is my recommended way to open this file in RStudio with correct formatting and headers 

```R
#column names
tagcolnames <- c("datetime", "fracsec", "duration", "tagtype", "PITnum", 
                 "consdetc", "arrint", "site", "manuf", "srcfile", "srcline", "compdate")

#read the file into R with correct column formats 
tdat <- read_csv(paste(dbDir,"/tagDB.csv", sep=""), col_names=tagcolnames,
                 col_types = cols(datetime=col_datetime(format = ""),
                                  fracsec="d", duration="d", tagtype="c", PITnum="c",
                                  consdetc="i", arrint="i", site="c", manuf="c",
                                  srcfile="c", srcline="i", compdate=col_date(format = "%Y-%m-%d")))
```


+ `datetime`: raw date and time
+ `fracsec`: raw data collection fraction of a second for the time
+ `duration`: duration tag was in the field 
+ `tagtype`: tag type (A for ISO animal format, R for read-only, W for writeable tag; OregonRFID)
+ `PITnum`: the PIT tag number
+ `consdetc`: consecutive detections count  
+ `arrint`: number of empty scans prior to the detection
+ `site`: site name 
+ `manuf`: equipment manufacturer (ORFID or Biomark)
+ `srcfile`: the raw PIT tag data source file path
+ `srcline`: the raw PIT tag data source file line
+ `compdate`: the date this entry was compiled

***Note***: if you open tagDB.csv in excel, the PITnum column will be a 
'general' format and will display the tag numbers in scientific notation (i.e., 435 x 10^16). If you 
change the tag column to 'number' format, excel will display the full tag number.
Excel is not my recommended way to view tagDB.csv, or any of the output files. I recommend directly importing into R, or using Notepad++.

**metaDB_OR.csv**: these are metadata from OregonRFID readers




