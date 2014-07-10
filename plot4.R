# Load data ---------------------------------------------------------------------
# check if we already have hh_pc DataFrame in environment
if(!'hh_pc' %in% ls()) {
    #check that file not loaded and load
    if(!'hh_pc.zip' %in% list.files()) {
        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 
                      'hh_pc.zip', method='curl')
    }
    # read all
    pc <- read.csv(unz('hh_pc.zip', filename='household_power_consumption.txt'), 
                   sep=';', as.is=T, na.strings=c('?'))
    # add datetime column
    pc$dtm <- strptime(paste(pc$Date, pc$Time, sep=' '), 
                       format='%d/%m/%Y %H:%M:%S')
    # filter 2 days interval
    hh_pc <- pc[pc$dtm >= as.POSIXlt('2007-02-01') & pc$dtm < as.POSIXlt('2007-02-03'),]
    rm(pc)
}


# plotting ----------------------------------------------------------------
png(file = "plot4.png")
par(mfrow=c(2,2))
plot(hh_pc$dtm, hh_pc$Global_active_power, type='l', xlab=NA, ylab='Global Active Power')
plot(hh_pc$dtm, hh_pc$Voltage, type='l', xlab='datetime', ylab='Voltage')
plot(c(hh_pc$dtm[1], hh_pc$dtm[nrow(hh_pc)]), 
     c(0, max(hh_pc[,c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')])), 
     type='n', xlab=NA, ylab='Energy sub metering')
lines(hh_pc$dtm, hh_pc$Sub_metering_1)
lines(hh_pc$dtm, hh_pc$Sub_metering_2, col='red')
lines(hh_pc$dtm, hh_pc$Sub_metering_3, col='blue')
legend(x='topright', c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       col=c('black', 'red', 'blue'), lwd=1, bty='n', cex=.8)
plot(hh_pc$dtm, hh_pc$Global_reactive_power, type='l', xlab='datetime', ylab='Global_reactive_power')
dev.off()

