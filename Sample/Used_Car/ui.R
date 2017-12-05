#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(data.table)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
path = '/Users/ningchen/Documents/UserCar_Shiny/'  ###### Check 1 ######
#Path Example(Mac): '/Users/kristen/Desktop/Azureml-shiny-app-master/Shiny_Titanic'
#Path Example(Windows): 'C:/Users/kristen/Desktop/Azureml-shiny-app-master/Shiny_Titanic' 
#                    or 'C:\\Users\\kristen\\Desktop\\Azureml-shiny-app-master\\Shiny_Titanic'


#---- Data ----
data <- fread(file.path(path, "usedcar1209.csv"))
#data<-read.csv("usedcar1209.csv")
#---- selectInput for classfication variable ----
vehicleType <- sort(unique(data$vehicleType))
gearbox <- sort(unique(data$gearbox))
ifRepair <- sort(unique(data$notRepairedDamage))

#---- sliderInput ----
powerPS <- data.frame( max = max(data$powerPS ,na.rm =TRUE), 
                    min = min(data$powerPS ,na.rm =TRUE) )


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
      sliderInput("powerPS", "powerPS : ", min = powerPS$min, max = powerPS$max, value = powerPS$max, step = 1, sep='')
    ),
    mainPanel( textOutput("result_text") )
  )
  
))

