#converts ECCC hourly data into daily average values and combines with daily ECCC data#
#Mariaelisa Polsinelli for AAFC#

library(data.table)
library(dplyr)

#set working directory. Change Station ID/file name as necessary
stn_names <- c("Ste-Anne")
parent_dir <- "C:/Users/PolsinelliM/OneDrive - AGR-AGR/Documents/McGill/BREE 533/Project/RZWQM/"

#years to examine
yrs <- c(2018,2021)

#Edit columns of data from weather data table to calculate averages for
#14 - RH, 20 - wind speed
cols <- list(c('RH',14),c("Wind Speed",20))


#~~~~~~~~~~~FORMAT csv file~~~~~~~~~~~~~~~~~~~~~~~~~~~

createClimFile = function(stn,years){
  #creates complete climate file for each weather station
  wd <- paste(parent_dir,stn,sep="")
  setwd(wd)
  fnm <- paste(stn,"_climatefile.csv",sep="")
  first <- T
  
  for (y in years){
    cur_dlyyr <- read.csv(file = paste(wd,"/",y,"/",stn,"_",y,"_ECCC.csv",sep=""),header=TRUE, sep=",") %>% select(5,6,7,8,10,12,24)
    if (first){
      first <- F
      write.csv(cur_dlyyr,file = fnm, row.names=F)
    }else{
      write.table(cur_dlyyr,file= fnm, append = T, col.names = F, row.names = F, sep=",")
    }
  }
}

#~~~~~~~~~~~Calculate AVGS~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_avgs <- function(data,col){

    daily_sum <- 0 #sum of hourly data
    denom <- 0 #denomenator for avg calc
    hr <- 24 
    avgs <- c()
    
    for (i in data[,col]){
      if (!(hr==0)){
        hr <- hr - 1
      }else{
        #write to table
        avgs <- append(avgs,daily_sum/denom)
        #reset counters
        daily_sum <- 0
        denom <- 0
        hr <- 23
      }
      if (!(is.na(i))){
        denom <- denom + 1
        daily_sum <- daily_sum + i
      }
    }
  avgs <- append(avgs,daily_sum/denom)
  return(avgs)
}

calcAVGS <- function(stn,yrs,colnum){
  
  wd <- paste(parent_dir,stn,sep="")

  data <- c()
  i <- 1
  
  for(y in yrs){
    fstem <- paste(wd,"/",y,"/","hourly_",y,"_",sep="")
    while(i <= 12){
      cur_hrly <- read.csv(paste(fstem,i,".csv",sep=""))
      data <- append(data,get_avgs(cur_hrly,colnum))
      i <- i + 1
    }
    i <- 1
  }
  return(data)
}

#~~~~~~~~~~Create Climate Files~~~~~~~~~~~~
yrs <- seq(yrs[1],yrs[2])

for (s in stn_names){
  #create climate file for each station
  createClimFile(s,yrs)
  fnm <- paste(s,"_climatefile.csv",sep="")
  climFile <- read.csv(file=fnm)
  for (v in cols){
    #generate daily averages for each selected hourly parameter
    pd <- calcAVGS(s,yrs,as.integer(v[2]))
    climFile$new_col <- pd
    names(climFile)[ncol(climFile)] <- v[1]
  }
  write.csv(climFile,file = fnm, col.names = T, row.names = F)
}



  
    
    