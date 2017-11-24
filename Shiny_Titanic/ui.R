#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(data.table)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
path = ' Your File Path '  ###### Check 1 ######
#Path Example(Mac): '/Users/kristen/Desktop/'
#Path Example(Windows): 'C:/Desktop/'

#---- Load Data ----
Titanic_train <- fread(file.path(path, "Titanic_train.csv")) %>% select(-Survived)
Titanic_test <- fread(file.path(path, "Titanic_test.csv"))

#---- Bind Data ----
Titanic_data <- rbind(Titanic_train,Titanic_test)
rm(Titanic_train,Titanic_test)

#---- selectInput for classfication variable ----
pclass <- sort(unique(Titanic_data$PassengerClass))
gender <- sort(unique(Titanic_data$Gender))
embarked <- sort(unique(Titanic_data$PortEmbarkation[Titanic_data$PortEmbarkation != ""]))

#---- sliderInput ----
fare <- data.frame( max = max(Titanic_data$FarePrice ,na.rm =TRUE), 
                    min = min(Titanic_data$FarePrice ,na.rm =TRUE) )

#---- numericInput ----
age <- data.frame( max = floor(max(Titanic_data$Age ,na.rm =TRUE)), 
                   min = floor(min(Titanic_data$Age ,na.rm =TRUE)) ) 
sibSp <- data.frame( max = max(as.numeric(Titanic_data$SiblingSpouse),na.rm =TRUE), 
                     min = min(as.numeric(Titanic_data$SiblingSpouse),na.rm =TRUE) ) 
parch <- data.frame( max = max(as.numeric(Titanic_data$ParentChild),na.rm =TRUE), 
                     min = min(as.numeric(Titanic_data$ParentChild),na.rm =TRUE) )


#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("Titanic Survival Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("PassengerClass", "Passenger Class : ", choices=pclass),
      selectInput("Gender", "Gender : ", choices=gender),
      selectInput("PortEmbarkation", "Port Embarkation : ", choices=embarked),
      numericInput("Age", "Age : ", min = age$min, max = age$max, value =age$max, step = 0.5),
      numericInput("SiblingSpouse", "Sibling Spouse : ", min = sibSp$min, max = sibSp$max, value =sibSp$max, step = 1),
      numericInput("ParentChild", "Parent Child : ", min = parch$min, max = parch$max, value =parch$max, step = 1),
      sliderInput("FarePrice", "Fare Price : ", min = fare$min, max = fare$max, value = fare$max, step = 0.0001, sep='')
    ),
    mainPanel( imageOutput("result_plot") )
  )
  
))


