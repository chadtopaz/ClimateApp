library("shiny")

shinyUI(
  
  pageWithSidebar(
    
    headerPanel("Visualizing climate data"),  
    
    sidebarPanel(      
      h4("Documentation"),
      helpText("This applet downloads, processes, and visualizes data from the National Atmospheric and Oceanic Administration's Normals Daily database. Full documentation on this dataset is available at:"),
      helpText("http://www.ncdc.noaa.gov/cdo-web/datasets"),
      helpText("To use the applet, enter a vald five-digit U.S. zipcode, select a climate variable to view, and press submit. Because data is downloaded and processed dynamically from NOAA, please allow several moments for the data refresh at the right. Occasionally, the NOAA server goes down. If you receive any error, please wait a few mintues and try your query again."),
      h4("Inputs"),
      h4("Geographic Location"),
      textInput(inputId="zipcode",label="U.S. zip code of interest", value="55105"),
      h4("Climate Data Type"),
      selectInput(inputId="whichdata",label="Select a type of climate data",choices=c("Average temperature","Minimum temperature","Maximum temperature","Probability of precipitation","Probability of snowfall"), selected="Average temperature"),
      submitButton("Submit")
    ),
    
    mainPanel(
      h4('Result of server calculations:'),
      h4('Long term averages, 1981 - 2010'),
      plotOutput("dataPlot")
    )
    
  )
  
)