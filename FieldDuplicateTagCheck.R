
require(xlsx)
require(tidyverse)

# Main fish data file
load(dbDir)
# Compile new data
dir = dataDir

files = list.files(dir, '*.xlsx', recursive = F, full.names = TRUE) 
bnames = basename(files)
bnames = sub('.xlsx', '',bnames)

for(i in 1:length(files)){
  tbl = read.xlsx2(files[i], sheetIndex = 1, startRow = 1, 
                   colClasses = c("character","Date", "numeric", "numeric", "numeric", "numeric",
                                  "character","numeric", "character", "character", "character", 
                                   "character", "character"),
                   stringsAsFactors=FALSE)
  if(i == 1){
    fallpop = tbl
  } else{
    fallpop = rbind(fallpop, tbl)
  }
}

colnames(fallpop) <- c("SiteID", "Date", "FishNum", "Pass", "FL_mm", "Wt_g", "PITnum", "TagSize",  
                       "DNAsamp", "Scales", "Recap","Species", "Notes")


fallpop$DNAsamp <- fallpop$DNAsamp=="Y" | fallpop$DNAsamp=="T"
fallpop$Scales <- fallpop$Scales=="Y" | fallpop$Scales=="T"
fallpop$Recap <- fallpop$Recap=="Y" | fallpop$Recap=="T"
fallpop$Sex<-NA
fallpop$SiteTo<-NA
fallpop$TagSize <- as.integer(fallpop$TagSize)
fallpop$PITnum = as.character(sub(" ", "", fallpop[,"PITnum"])) # Remove space from PITnum

#... Clean up tag numbers
fallpop$PITnum[fallpop$PITnum=="NaN"] <- NA
fallpop$PITnum[fallpop$PITnum==""] <- NA

##... print first 6 lines of fall pop, confirm code is working
print("Fall pop data looks like this:")
print(head(fallpop[,1:8]))

#... Bind with main data file
AFD <- rbind(AFD, fallpop)

##... print first 6 lines of AFD, confirm code is working
print("Main fish data looks like this:")
print(head(AFD[,1:8]))

#... Check for and return duplicates
Tdat <- filter(AFD, Recap==F, !is.na(PITnum)) #Non-recaps
dupTags <- Tdat[which(duplicated(Tdat$PITnum)==T) , ]
idx <- duplicated(Tdat$PITnum) | duplicated(Tdat$PITnum, fromLast = TRUE) 

##... print the duplicates
print("Here are the duplicates:")
print(Tdat[idx, c(1, 2, 4, 7)])
