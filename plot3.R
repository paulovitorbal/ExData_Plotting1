#this function will check, and try to install the packages needed
verifyDepencies<- function(){
  print("Verifying dependencies.")
  packageName <- "sqldf"
  if (!require(packageName,character.only = TRUE))
  {
    install.packages(packageName,dep=TRUE)
    if(!require(packageName,character.only = TRUE)) stop(paste("Package ", packageName, "not found. The script cannot continue."))
    library(sqldf)
  }
}
#this function will try to download the data file, if needed, and create the data dir
downloadFile <- function () {
  remotefile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
  if (!dir.exists("data")){
    dir.create("data");
    print("Creating data dir.");
  }else{
    print("Data dir already created, using it.");
  }
  
  if (!file.exists("data/data.zip")){
    print("downloading remote data file to data/data.zip");
    download.file(remotefile, "data/data.zip");
  }else{
    print("Using file at: data/data.zip");
  }
  
  if (dir("data")[1] == "data.zip" && length(dir("data")) == 1){
    print("uncompressing zipped data to data/");
    unzip("data/data.zip",exdir = "data")
  }else{
    print("data already uncompressed, using it.")
  }
  
}
#this function will get the data inside that is between 1/2/2007 and 2/2/2007
getDataOnRange <- function(){
  print("Reading data");
  SQL<-"SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
  Data <- read.csv.sql("data/household_power_consumption.txt", sql=SQL, sep=";")
  Data$DateTime <- as.POSIXct(strptime(paste(Data$Date,Data$Time), "%d/%m/%Y %H:%M:%S"))
  print(paste("selected:",nrow(Data), "rows, with", length(Data), "variables"))
  Data
}
#this function will plot the third graph
plot3 <- function(data){
  print("generating image plot1.png, wait...")
  Sys.setlocale("LC_ALL","English") #in order to make the weekdays in english, I will force the locale
  png(filename = "plot3.png", width = 480, height = 480)
  plot(data$DateTime, data$Sub_metering_1, type = 'l', ylab = 'Energy sub metering', xlab = '')
  points(data$DateTime, data$Sub_metering_2, type = 'l', col = 'red')
  points(data$DateTime, data$Sub_metering_3, type = 'l', col= 'blue')
  legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = c(1, 1, 1))
  dev.off()
  print("image generated!")
}

#calling the functions
verifyDepencies()
downloadFile()
data<-getDataOnRange()
plot3(data)
rm(data)