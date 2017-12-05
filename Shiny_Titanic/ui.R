#===========================================================================
# Library
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
pclass <- c(1,2,3)
gender <- c("female","male")
embarked <- c("C","Q","S")

#---- sliderInput ----
fare_max = 512.35
fare_min = 0

#---- numericInput ----
age_max = 80
age_min = 0

sibSp_max = 8
sibSp_min = 0

parch_max = 9
parch_min = 0

#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("Titanic Survival Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "PassengerClass",
                   label = "Passenger Class : ", 
                   choices = pclass),
      
      selectInput( inputId = "Gender", 
                   label = "Gender : ", 
                   choices=gender),
      
      selectInput( inputId = "PortEmbarkation", 
                   label = "Port Embarkation : ", 
                   choices=embarked),
      
      numericInput( inputId = "Age", 
                    label = "Age : ", 
                    min = age_min, max = age_max, value =age_max, step = 0.5),
      
      numericInput( inputId = "SiblingSpouse", 
                    label = "Sibling Spouse : ", 
                    min = sibSp_min, max = sibSp_max, value =sibSp_max, step = 1),
      
      numericInput( inputId = "ParentChild", 
                    label = "Parent Child : ", 
                    min = parch_min, max = parch_max, value =parch_max, step = 1),
      
      sliderInput( inputId = "FarePrice", 
                   label = "Fare Price : ", 
                   min = fare_min, max = fare_max, value = fare_max, step = 0.0001, sep='')
    ),
    mainPanel( imageOutput("result_plot") )
  )
  
))


