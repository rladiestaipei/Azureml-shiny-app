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
#---- Setting path ----
# path = '/Users/kristen/Desktop/Azure_ML_Titanic/'
path = getwd()

#---- Load Data ----
Azure_ML_train <- fread(file.path(path, "Azure_ML_train.csv")) %>% select(-Survived)
Azure_ML_test <- fread(file.path(path, "Azure_ML_test.csv"))

#---- Bind Data ----
Azure_ML_data <- rbind(Azure_ML_train,Azure_ML_test)
rm(Azure_ML_train,Azure_ML_test)

#---- selectInput for classfication variable ----
Pclass <- sort(unique(Azure_ML_data$PassengerClass))
gender <- sort(unique(Azure_ML_data$Gender))
Embarked <- sort(unique(Azure_ML_data$PortEmbarkation[Azure_ML_data$PortEmbarkation != ""]))

#Azure_ML_data %>% select(PortEmbarkation) %>% distinct(PortEmbarkation) %>% arrange(PortEmbarkation)

#---- sliderInput ----
Fare <- data.frame( max = max(Azure_ML_data$FarePrice ,na.rm =TRUE), 
                    min = min(Azure_ML_data$FarePrice ,na.rm =TRUE), 
                    mode = as.numeric(names(table(Azure_ML_data$FarePrice)))[table(Azure_ML_data$FarePrice) == max(table(Azure_ML_data$FarePrice))] 
                  )

#---- numericInput ----
age <- data.frame( max = floor(max(Azure_ML_data$Age ,na.rm =TRUE)), 
                   min = floor(min(Azure_ML_data$Age ,na.rm =TRUE)), 
                   mode = floor(as.numeric(names(table(Azure_ML_data$Age)))[table(Azure_ML_data$Age) == max(table(Azure_ML_data$Age))])
                  ) 
SibSp <- data.frame( max = max(as.numeric(Azure_ML_data$SiblingSpouse),na.rm =TRUE), 
                     min = min(as.numeric(Azure_ML_data$SiblingSpouse),na.rm =TRUE), 
                     mode = as.numeric(names(table(Azure_ML_data$SiblingSpouse)))[table(Azure_ML_data$SiblingSpouse) == max(table(Azure_ML_data$SiblingSpouse))] 
                    ) 
Parch <- data.frame( max = max(as.numeric(Azure_ML_data$ParentChild),na.rm =TRUE), 
                     min = min(as.numeric(Azure_ML_data$ParentChild),na.rm =TRUE), 
                     mode = as.numeric(names(table(Azure_ML_data$ParentChild)))[table(Azure_ML_data$ParentChild) == max(table(Azure_ML_data$ParentChild))] 
                   )  

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
      numericInput("Age", "Age : ", min = age$min, max = age$max, value =age$mode, step = 0.5),
      numericInput("SiblingSpouse", "SiblingSpouse : ", min = SibSp$min, max = SibSp$max, value =SibSp$mode, step = 1),
      numericInput("ParentChild", "ParentChild : ", min = Parch$min, max = Parch$max, value =Parch$mode, step = 1),
      sliderInput("FarePrice", "FarePrice : ", min = Fare$min, max = Fare$max, value = Fare$mode, step = 0.0001, sep='')
    ),
    mainPanel( imageOutput("result_plot") )
  )
  
))
