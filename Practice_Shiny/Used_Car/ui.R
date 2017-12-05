#===========================================================================
# Library
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
vehicleType = c("bus","cabrio","coupe","kleinwagen","kombi","limousine","suv")
gearbox = c("automatik","manuell")
ifRepair = c("ja","nein")

#---- sliderInput ----
powerPS_max = 10910
powerPS_min = 0

#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("二手車車價預測"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("vehicleType", "vehicleType : ", choices=vehicleType),
      selectInput("gearbox", "Gearbox : ", choices=gearbox),
      selectInput("ifRepair", "IfRepair : ", choices=ifRepair),
      sliderInput("powerPS", "powerPS : ", min = powerPS_min, max = powerPS_max, value = powerPS_max, step = 1, sep='')
    ),
    mainPanel( textOutput("result_text") )
  )
  
))

