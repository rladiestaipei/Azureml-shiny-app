#===========================================================================
# Library
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
workclass <- c("Private","Local-gov","Self-emp-not-inc","Federal-gov","State-gov")
education <- c("1","2")
maritalstatus <- c("Married-civ-spouse","Never-married","Divorced","Separated","Widowed")
occupation <- c("Machine-op-inspct","Farming-fishing","Protective-serv","Other-service","Prof-specialty","Craft-repair","Adm-clerical","Exec-managerial","Tech-support","Sales","Priv-house-serv","Handlers-cleaners","Transport-moving")
relationship <- c("Own-child","Husband","Not-in-family","Unmarried","Husband","Unmarried","Wife","Other-relative")
race <- c("Black","White","Asian-Pac-Islander","Other")
gender <- c("Female","Male")
nativecountry <- c("United-States","Guatemala","Mexico","Peru","Ireland","Thailand","Haiti","Vietnam","Puerto-Rico","Dominican-Republic","Germany","Poland","Laos","England","India","Philippines")
income <- c("<=50K",">50K")

#---- sliderInput ----
age_max = 72
age_min = 18

fnlwgt_max = 450000
fnlwgt_min = 0

cg_max = 15000
cg_min = 0

cl_max = 3000
cl_min = 0

#---- numericInput ----
edu_max = 15
edu_min = 0

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
      
      selectInput( inputId = "education",
                   label = "Education : ", 
                   choices = education),
      
      numericInput( inputId = "educationalnum", 
                    label = "Education Num : ", 
                    min = edu_min, max = edu_max, value = edu_max, step = 1),
      
      selectInput( inputId = "maritalstatus",
                   label = "Marital Status : ", 
                   choices = maritalstatus),
      
      selectInput( inputId = "occupation",
                   label = "Occupation : ", 
                   choices = occupation),
      
      selectInput( inputId = "relationship",
                   label = "Relationship : ", 
                   choices = relationship),
      
      selectInput( inputId = "race",
                   label = "Race : ", 
                   choices = race),
      
      selectInput( inputId = "gender", 
                   label = "Gender : ", 
                   choices = gender),    
      
      sliderInput( inputId = "capitalgain", 
                   label = "Capital Gain : ", 
                   min = cg_min, max = cg_max, value = cg_max, step = 1, sep=''),
      
      sliderInput( inputId = "capitalloss", 
                   label = "Capital Loss : ", 
                   min = cl_min, max = cl_max, value = cl_max, step = 1, sep=''),
      
      numericInput( inputId = "hoursperweek", 
                    label = "Hours per week : ", 
                    min = hpw_min, max = hpw_max, value = hpw_max, step = 5),
      
      selectInput( inputId = "nativecountry", 
                   label = "Native Country : ", 
                   choices = nativecountry),
      
      selectInput( inputId = "income", 
                   label = "Income : ", 
                   choices = income)
    ),
    mainPanel( imageOutput("result_plot") )
  )
  
))


