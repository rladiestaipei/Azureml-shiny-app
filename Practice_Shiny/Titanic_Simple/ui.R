#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(markdown)
library(data.table)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================


#---- selectInput for classfication variable ----
Pclass <- c(1,2,3)
gender <- c("female","male")

#---- numericInput ----
age_max = 80
age_min = 0


#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("Titanic Survival Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("PassengerClass", "PassengerClass : ", choices=Pclass),
      selectInput("Gender", "Gender : ", choices=gender),
      numericInput("Age", "Age : ", min = age_min, max = age_max, value =age_max, step = 1)
    ),
    mainPanel( h1(textOutput("result_text")) )
  )
  
))
