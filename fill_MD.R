#Replace missing data from ECCC with NasaPower Values (and adds Solar Radiation
#data from NasaPower)
#Created by Mariaelisa Polsinelli, 2022

parent_dir <- "C:/Users/PolsinelliM/OneDrive - AGR-AGR/Documents/McGill/BREE 533/Project/RZWQM/"
setwd(parent_dir)

#weather station name list
stn_list <- c("Ste-Anne")

#year range
#assumes ECCC weather data and NasaPower data are in the same range
#yrs <- c(2017,2021)


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
#find and replace missing values
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
  #run for each station in station list
  climateFile <- read_climateFile(s)
  NPfile <- read_NP_file(s)
  
  climateFile$SolarRadiation <- NPfile$ALLSKY_SFC_SW_DWN #add solar radiation data
  
  write.csv(get_missing(climateFile,NPfile,c(5,6,7),c(9,10,11)), file = paste(s,"_climComp.csv",sep=""), row.names = F)
  
}