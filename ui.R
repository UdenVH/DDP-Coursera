#
# ui code for Coursera "Developing Data Products"-project
#
# purpose: Show the expansion of the association "Brabantse Wijnbouwers", a community of hobby grapegrowers in  Belgium and the Netherlands. 
#
# run from the directory where this file can be found with:
# runApp(".")
#
# UdenVH, 09/01/2015
#

# setwd("~/Documents/Coursera - Developing Data Products/project/bwb")
library(shiny)

selection <- c("The Netherlands (NL)" = "NL","Belgium (BE)" = "BE")

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Expansion of the association 'Brabantse Wijnbouwers'"),
  p("The 'Brabantse Wijnbouwers' are a Dutch speaking community of hobby grapegrowers and winemakers 
    in Belgium and the Netherlands. 
    The association was founded in 2006 and aims to spread knowledge on cool climate vineyards 
    and wine making amongst its members and others with an interest in winemaking. Since its founding the association has grown from 
    7 to a little over 350 members.",br(),br(),"You can view the expansion over the years by moving the 'years'-slider, select on vineyard-size (measured in number of vines) and select the vineyards in Belgium and/or The Netherlands with the check-box."),
  sidebarLayout(
    # Sidebar with a slider input for years since founding the association.
    sidebarPanel(
      sliderInput("years", 
                  "Years since founding in 2006:",
                  min = 0,
                  max = 9, 
                  value = 0,
                  step = 1),
      br(),
      radioButtons("size", 
                   label = "Size of the vineyard:", 
                   choices = c("small (less or equal to 250 vines)" = "s",
                               "large (more then 250 vines)" = "l",
                               "all"   = "a"),
                   selected = "a"
                   ),
      br(),
      checkboxGroupInput("country",
                         "Countries:",
                         choices = selection,
                         selected = selection,
      ),
      # force some space between less important imput:
      br(),
      hr(),
      sliderInput("plotSize", 
                  "Map-size in pixels (adjust to your screen):", 
                  min = 400,
                  max = 1100, 
                  value = 700,
                  step = 100)
    ),
    
    # Show a plot of the distribution of members over Belgium and the Netherlands as a function of time since founding the association.
    mainPanel(
      plotOutput("showExpansion")
    )
),
p(strong("Data source:")," http://www.brabantsewijnbouwers.nl",br(),
  strong("Note:")," the data is the result of a data-mining",br(),
 "exercise where html-scraping with R was applied",br(),
 "to the membership-page on this website.")
))
