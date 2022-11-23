#-----------------------------
#Pull nasapower data from multiple coordinates/weather stations and save as .csv
#Mariaelisa Polsinelli for OMAFRA and AAFC
#May 2022
#-----------------------------

if (!require("nasapower")){
  install.packages("nasapower")
}
library(nasapower)


#set working directory to save files into
#default is the source directory
#setwd(getwd())
setwd("C:/Users/PolsinelliM/OneDrive - AGR-AGR/Documents/McGill/BREE 533/Project/RZWQM")

#list of weather station names and coordinates to extract data from
#add new station as sc[[number]] <- c("county name", longitude, latitude)
sc <- list()
sc[[1]] <- c("Ste-Anne", -73.93,45.43)

#parameters - selected weather data types
#all data types and their abbreviations can be found here https://power.larc.nasa.gov/#resources
#"ALLSKY_SFC_SW_DWN" - all sky surface shortwave downward irradiance (MJ/m^2/day)
#"T2M_MAX" - max temperature (C)
#"T2M_MIN" - min temperature (C)
#"PRECTOTCORR" - precipitation (mm)
climate_data <- c("T2M_MAX","T2M_MIN","PRECTOTCORR","ALLSKY_SFC_SW_DWN")

#choose "hourly", "daily" or "monthly"
time_period <- "daily"

#select date range of data to download (start and end date as "yyyy-mm-dd")
#as.character(Sys.Date()) = current date
date_ranges <- c("2018-01-01","2021-12-31")

#---CODE BEGINS---------------------------------------------------------------------------

#function to cal get_power for one coordinate set
download_nasapower = function(coordinates, pars_list, date_list,temporal_type ){
  output_file <- get_power(community = "ag",lonlat = coordinates, pars = pars_list, dates = date_list, temporal_api = temporal_type)
  return(output_file)
}

#while loop to parse through station list and call download_nasapower for each coordinate
i <- 1
while (i <= length(sc)){
  power_file <-  download_nasapower(c(as.numeric(sc[[i]][2]),as.numeric(sc[[i]][3])), climate_data, date_ranges, time_period)
  filename <- paste(sc[[i]][1], "nasapower",".csv",sep="_")
  write.csv(power_file, file = filename )
  i <- i + 1
}