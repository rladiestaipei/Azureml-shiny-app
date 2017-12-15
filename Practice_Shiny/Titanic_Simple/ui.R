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
Embarked <- c("C","Q","S")

#Azure_ML_data %>% select(PortEmbarkation) %>% distinct(PortEmbarkation) %>% arrange(PortEmbarkation)

#---- sliderInput ----
fare_max = 512.35
fare_min = 0

#---- numericInput ----
age_max = 80
age_min = 0

SibSp_max = 8
SibSp_min = 0

Parch_max  = 9
Parch_min  = 0

#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("Titanic Survival Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("PassengerClass", "PassengerClass : ", choices=Pclass),
      selectInput("Gender", "Gender : ", choices=gender),
      selectInput("PortEmbarkation", "PortEmbarkation : ", choices=Embarked),
      numericInput("Age", "Age : ", min = age_min, max = age_max, value =age_max, step = 1),
      numericInput("SiblingSpouse", "SiblingSpouse : ", min = SibSp_min, max = SibSp_max, value =SibSp_max, step = 1),
      numericInput("ParentChild", "ParentChild : ", min = Parch_min, max = Parch_max, value =Parch_max, step = 1),
      sliderInput("FarePrice", "FarePrice : ", min = fare_min, max = fare_max, value = fare_min, step = 0.0001, sep=''),
      submitButton('Submit')
    ),
    mainPanel( h1(textOutput("result_text")) )
  )
  
))
