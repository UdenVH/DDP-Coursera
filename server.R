#
# server code for Developing Data Products-project
#
# UdenVH, 09/01/2015
#
# documentation:
#  - Scoping (http://rstudio.github.io/shiny/tutorial/#scoping)

#install.packages("shiny")
#install.packages("ggmap")
library(shiny)
library(ggmap)

# load data (run once)
load("./data/ledenBWB.RData")
attach(ledenBWB)

# get a map of Belgium and The Netherlands (run once)
map <- get_map(location = c(lon=5.1189025, lat=51.5258257), zoom = 7)

# Define server logic
shinyServer(function(input, output) {
  
  # Return a number based on the plot-size parameter-value for resizing the plot:
  plotSize <- reactive({
    size <- input$plotSize
    if (size == '') size <- 600
    size
  })
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$showExpansion <- renderPlot({
    # subset the ledenBWB Data Frame and keep the members from the year of 
    # founding the association up to the year provided by the input slider.
    year <- 2006 + input$years
    membersSubset <- ledenBWB[Year <= year,]
    
    # subset on the size of the vineyard provided by the input slider.
    if (input$size == "s") 
       membersSubset <- membersSubset[membersSubset$VineCount <= 250,]
    else if (input$size == "l") 
      membersSubset <- membersSubset[membersSubset$VineCount > 250,]
    # else keep all (don't subset)
    
    # subset on the country of origin provided by the checkbox.
    membersSubset <- membersSubset[membersSubset$Country %in% input$country,]

    # define the caption text:
    caption <- "Vineyard location and sizes"
    if (toString(input$country) != "") caption <- paste(caption, "in", toString(input$country))
    caption <- paste(caption, "( year ", toString(year), ")")
    
    # the legend defines the size of the vineyards (make also selectable)
    legend <- c(1,5,10,50,100,500,1000,5000)
    
    # plot the member distribtution (in green: #008B00) on the map:
    p <- ggmap(map)
    p <- p + geom_point(mapping = aes(x = Lon, y = Lat, size = sqrt(VineCount)), colour="#FF7300", data = membersSubset, alpha = .75, na.rm = TRUE, show_guide = TRUE)
    p <- p + scale_size_area(breaks = sqrt(legend), labels = legend, limits=c(1, 120), name = "vineyard size")
    p + ggtitle(caption)
  }
  , width=plotSize, height=plotSize)
})
