##read the first row of data to find out with what date and time the 
##measurements start.
frow <- read.table("household_power_consumption.txt",header = TRUE,nrows=1,sep=';',colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),strip.white = TRUE, na.strings = c("?",""))
##Knowing that the measurements were taken every minute
##we can find the time difference between the 2007-02-01 00:00:00 and the 
##date and time in the first row of data - that way will find the number of 
##rows we need to skip when reading the data.
starttime <- as.POSIXct(strptime(paste(as.character(frow[1,1]),as.character(frow[1,2]),sep=" "), format="%d/%m/%Y %H:%M:%S"))
skiprows <- as.numeric(difftime(as.POSIXct("2007-02-01 00:00:00"),starttime,units="mins"))

##count time difference in minutes between 2007-02-01 00:00:00 and 
##2007-02-03 00:00:00 to find out number of rows we need to read from original 
##data to get a subset of required data, without the need to read the whole
##2075259 rows
numrows <- as.numeric(difftime(as.POSIXct("2007-02-03 00:00:00"),as.POSIXct("2007-02-01 00:00:00"),units="mins"))
##read the subset of the origianl data
data <- read.table("household_power_consumption.txt",header = TRUE,skip=skiprows,nrows=numrows,sep=";",colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),strip.white = TRUE, na.strings = c("?",""))
##give the meaningful column names to our data set
colnames(data) <- colnames(frow)
time <- paste(data$Date, data$Time)
data$Time <- strptime(time, "%d/%m/%Y %H:%M:%S")
##creating a plot and saving it to png
##I use default white background, unlike the transparent in samples on 
##github figure folder as all graphics viewers don't show transparency consistently, and 
##transparency is not stated as mandatory in the project requirements
png(filename="plot3.png",width=480,height=480,units="px")
plot(data$Time,data$Sub_metering_1,ylab="Energy sub metering",xlab="",type="n")
points(data$Time,data$Sub_metering_1,type="l")
points(data$Time,data$Sub_metering_2,type="l",col="red")
points(data$Time,data$Sub_metering_3,type="l",col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1,col=c("black","red","blue"))
dev.off()
