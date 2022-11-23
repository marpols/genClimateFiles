
parent_dir <- "C:/Users/PolsinelliM/OneDrive - AGR-AGR/Documents/McGill/BREE 533/Project/RZWQM/"
setwd(parent_dir)

#weather station name list
stn_list <- ("Ste-Anne")

#year range
yrs <- c(2018,2021)


#----------------------------------Funtions-------------------------------------
read_climateFile <- function(stn){
  #read climateFile for weather station
  weather_fp <- paste(getwd(), "/", stn,"/",stn,"_","climatefile","_",".csv", sep="")
  weather_dat <- read.csv(weather_fp)
  return(weather_dat)
}

read_NP_file <- function(stn) {
  #read corresponding NasaPower file for weather station
  NP_fp <- paste(getwd(), "/", stn,"/",stn,"_","nasapower","_",".csv", sep="")
  NP_data <- read.csv(NP_fp)
  return(NP_data)
}

#-------------------------------Code Begins ------------------------------------
