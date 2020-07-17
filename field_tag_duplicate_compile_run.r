#####################################################################################################################
### INPUTS ##########################################################################################################
#####################################################################################################################

##... functionsPath is where the R file 'FieldDuplicateTagCheck.r' is located
##... dbDir is where the main fish data file is located
##... dataDir is where the new fish data is located. NOTE: this should be in a different 
##... location from the functionsPath and dbDir

functionsPath = "C:/Users/HaleyOhms/Documents/GitHub/CaRmel_FieldTagCheck/FieldDuplicateTagCheck.r"
dbDir = "C:/Users/HaleyOhms/Documents/GitHub/CaRmel_FieldTagCheck/AllFishData.Rdata"
dataDir = "C:/Users/HaleyOhms/Documents/GitHub/CaRmel_FieldTagCheck"

#####################################################################################################################

##... Run the code: 

source(functionsPath)  

