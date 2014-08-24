library('shiny')
library('rnoaa')
library('plyr')
library('ggplot2')
library('zipcode')
library('scales')
data(zipcode)
options(noaakey = "wgFMCtZNFHeZzDBzRsNnPKeZcKvrwPSf")

displayNames <- c("Average temperature", "Minimum temperature", "Maximum temperature", "Probability of precipitation", "Probability of snowfall")
realNames <- c("dly-tavg-normal","dly-tmin-normal","dly-tmax-normal","dly-prcp-pctall-ge001hi","dly-snow-pctall-ge001ti")

getStation <- function(thiszip) {
  station <- NULL
  zipData <- subset(zipcode,zip==thiszip,select=c("latitude","longitude"))
  if (nrow(zipData) > 0) {
    loc <- as.numeric(zipData)
    station <- ncdc_stations(datasetid="NORMAL_DLY", extent=loc, limit = 1)[[2]]
  }
  return(station)
}

getData <- function(station,whichdata) {
  data <- ncdc(datasetid='NORMAL_DLY', stationid=station$id, datatypeid=whichdata, startdate = station$mindate, enddate = station$maxdate, limit = 1000)[[2]]
  if (!is.null(data)) {
    data$date <- as.Date(data$date)
  }
  return(data)
}

shinyServer(
  
  function(input, output) {    
    
    
    output$dataPlot <- renderPlot({
      p <- ggplot(data.frame()) + geom_blank() + xlim(0, 1) + ylim(0, 1) + ggtitle("No data available. Enter another query.")
      thiszip <- input$zipcode
      whichdata <- realNames[displayNames == input$whichdata]
      station <- getStation(thiszip)
      if (!is.null(station)) {
        data <- getData(station,whichdata)
        if (!is.null(data)) {
          if (input$whichdata == "Average temperature"){
            data$value <- data$value/10
            ylabel <- "Average temperature (Deg. Fahrenheit)"
          }
          if (input$whichdata == "Minimum temperature"){
            data$value <- data$value/10
            ylabel <- "Minimum temperature (Deg. Fahrenheit)"
          }
          if (input$whichdata == "Maximum temperature"){
            data$value <- data$value/10
            ylabel <- "Maximum temperature (Deg. Fahrenheit)"
          }
          if (input$whichdata == "Probability of precipitation"){
            data$value <- data$value/10
            ylabel <- "Probability of precipitation (%)"
          }
          if (input$whichdata == "Probability of snowfall"){
            data$value <- data$value/10
            ylabel <- "Probability of snow (%)"
          }
          p <- ggplot(data, aes(x=date, y=value/10)) + geom_line()
          p <- p + scale_x_date(labels = date_format("%B"))
          p <- p + xlab("Date") + ylab(ylabel)
          if (input$whichdata == "Probability of precipitation" | input$whichdata == "Probability of snow"){
            p <- p + expand_limits(y=0)
          }
        }
      }
      print(p)
    })
    
  })