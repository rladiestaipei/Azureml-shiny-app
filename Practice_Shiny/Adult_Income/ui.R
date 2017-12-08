#===========================================================================
# Library
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
workclass <- c("Private","Local-gov","Self-emp-not-inc","Federal-gov","State-gov")
occupation <- c("Machine-op-inspct","Farming-fishing","Protective-serv","Other-service","Prof-specialty","Craft-repair","Adm-clerical","Exec-managerial","Tech-support","Sales","Priv-house-serv","Handlers-cleaners","Transport-moving")
gender <- c("Female","Male")

#---- sliderInput ----
age_max = 72
age_min = 18

fnlwgt_max = 450000
fnlwgt_min = 0

#---- numericInput ----
hpw_max = 50
hpw_min = 10

#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(fluidPage( 
  
  titlePanel("預測成年人收入"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput( inputId = "age", 
                   label = "Age : ", 
                   min = age_min, max = age_max, value = age_max, step = 1, sep=''),
      
      selectInput( inputId = "workclass",
                   label = "Workclass Class : ", 
                   choices = workclass),
      
      sliderInput( inputId = "fnlwgt", 
                   label = "Final Wight : ", 
                   min = fnlwgt_min, max = fnlwgt_max, value = fnlwgt_max, step = 1, sep=''),
      
      selectInput( inputId = "occupation",
                   label = "Occupation : ", 
                   choices = occupation),
      
      selectInput( inputId = "gender", 
                   label = "Gender : ", 
                   choices = gender),    
      
      numericInput( inputId = "hoursperweek", 
                    label = "Hours per week : ", 
                    min = hpw_min, max = hpw_max, value = hpw_max, step = 5)
      
    ),
    mainPanel( imageOutput("result_plot") )
  )
  
))


