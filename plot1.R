### This script downloads the dataset from url, uploads it to R and replicates the Plot 1
### Skip the code up to "Creating the plot" if the dataset is already uploaded
############################################################################################

#download and unzip the dataset 
require(httr)
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile(fileext = ".zip")
GET(URL, write_disk(temp))
unzip(temp, exdir = "data")
unlink(temp)
rm(temp)

cat("Finished downloading the dataset ", list.files("data"))

#load the dataset into R
require(sqldf)
data <- read.csv.sql("data/household_power_consumption.txt", 
                     sql ="select * from file where Date in ('1/2/2007' ,'2/2/2007')",
                     sep = ";", header = TRUE)
closeAllConnections()
View(data)

#convert the variables to the appropriate types
data[data == "?"] <- NA
data$Time <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Global_active_power <- as.numeric(data$Global_active_power)

#----------------------------------------------------------------------------------------

#Making the plot 1

png('plot1.png', width = 480, height = 480, units = "px")
hist(data$Global_active_power, breaks = 12, freq = TRUE,
     col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()