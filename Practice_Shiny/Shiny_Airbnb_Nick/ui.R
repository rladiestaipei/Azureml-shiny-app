#===========================================================================
# Library
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
roomtype <- c("Shared room","Entire home/apt","Private room")

#---- sliderInput ----
neighborhood_max = 24
neighborhood_min = 1


accommodates_max = 16
accommodates_min = 1

bedroom_max = 6
bedroom_min = 1

#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  sidebarLayout(
    sidebarPanel(
      
      
      selectInput( inputId = "room_type",
                   label = "Room Type : ", 
                   choices = roomtype),
      
      sliderInput( inputId = "neighborhood", 
                   label = "Neighborhood : ", 
                   min = neighborhood_min, max = neighborhood_max, value =neighborhood_max, step = 1, sep=''),
      
      sliderInput( inputId = "accommodates", 
                   label = "Accommodates : ", 
                   min = neighborhood_min, max = accommodates_max, value =accommodates_max, step = 1, sep=''),
      
      sliderInput( inputId = "bedrooms", 
                   label = "Bedrooms : ", 
                   min = bedroom_min, max = bedroom_max, value =accommodates_max, step = 1, sep='')
    ),
    list(mainPanel( span(textOutput("result_text") ,style="font-size: 30px;font-family: impact;")),
    mainPanel = (imageOutput("result_plot") ))
  )
  
))

