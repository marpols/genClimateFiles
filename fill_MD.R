
parent_dir <- "C:/Users/PolsinelliM/OneDrive - AGR-AGR/Documents/McGill/BREE 533/Project/RZWQM/"
setwd(parent_dir)

#weather station name list
stn_list <- ("Ste-Anne")

#year range
yrs <- c(2018,2021)


#----------------------------------Funtions-------------------------------------
read_climateFile <- function(stn){
  #read climateFile for weather station
  weather_fp <- paste(getwd(), "/", stn,"/",stn,"_","climatefile.csv", sep="")
  weather_dat <- read.csv(weather_fp)
  return(weather_dat)
}

read_NP_file <- function(stn) {
  #read corresponding NasaPower file for weather station
  NP_fp <- paste(getwd(), "/", stn,"/",stn,"_","nasapower","_",".csv", sep="")
  NP_data <- read.csv(NP_fp)
  return(NP_data)
}

get_missing <- function(climfile,NPfile,climcols,NPcols){
 i <- 1
 while (i <= length(climcols)){
    c <- climcols[i]
    d <- NPcols[i]
    missing <- which(is.na(climfile[c]))
    for (j in missing){
      climfile[j,c] <- NPfile[j,d]
    }
    i <- i + 1
 }
 return(climfile)
}

#-------------------------------Code Begins ------------------------------------

for(s in stn_list){
  climateFile <- read_climateFile(s)
  NPfile <- read_NP_file(s)
  #add solar radiation data
  climateFile$SolarRadiation <- NPfile$ALLSKY_SFC_SW_DWN
  
  write.csv(get_missing(climateFile,NPfile,c(6,7,8),c(9,10,11)), file = paste(s,"_climComp.csv"))
  
}